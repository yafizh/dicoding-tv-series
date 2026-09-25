import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mock_blocs.dart';

void main() {
  late MockTVDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTVDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  TVDetailState loadedState({bool isAddedToWatchlist = false}) {
    return TVDetailState(
      tvState: RequestState.loaded,
      tv: testTVDetail,
      recommendationState: RequestState.loaded,
      isAddedToWatchlist: isAddedToWatchlist,
    );
  }

  testWidgets('Page should fetch the detail and watchlist status when opened', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVDetailState());

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    verify(() => mockBloc.add(const FetchTVDetail(1))).called(1);
    verify(() => mockBloc.add(const LoadTVWatchlistStatus(1))).called(1);
  });

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(const TVDetailState(tvState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'Page should display the title, rating and overview when loaded',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(loadedState());

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.text('name'), findsOneWidget);
      expect(find.text('overview'), findsWidgets);
      expect(find.text('${testTVDetail.voteAverage}'), findsOneWidget);
    },
  );

  testWidgets('Page should display the season and episode information', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.text('Seasons'), findsOneWidget);
    expect(find.byKey(Key('season_list')), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
    expect(find.text('10 episodes'), findsOneWidget);
    expect(find.text('1 Season(s) • 10 Episode(s)'), findsOneWidget);
  });

  testWidgets('Page should display the recommendation list', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byKey(Key('recommendation_list')), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(loadedState());

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(loadedState(isAddedToWatchlist: true));

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should remove the tv when it is already in watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(loadedState(isAddedToWatchlist: true));

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
      await tester.tap(find.byKey(Key('watchlist_button')));

      verify(() => mockBloc.add(RemoveTVFromWatchlist(testTVDetail))).called(1);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      final initial = loadedState();
      whenListen(
        mockBloc,
        Stream.value(initial.copyWith(watchlistMessage: 'Added to Watchlist')),
        initialState: initial,
      );

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
      await tester.tap(find.byKey(Key('watchlist_button')));
      await tester.pump();

      verify(() => mockBloc.add(AddTVToWatchlist(testTVDetail))).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      final initial = loadedState();
      whenListen(
        mockBloc,
        Stream.value(initial.copyWith(watchlistMessage: 'Failed')),
        initialState: initial,
      );

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
      await tester.tap(find.byKey(Key('watchlist_button')));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display error message when the request fails', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      const TVDetailState(
        tvState: RequestState.error,
        message: 'Server Failure',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.text('Server Failure'), findsOneWidget);
  });
}
