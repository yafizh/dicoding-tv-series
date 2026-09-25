import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:tv_series/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mock_blocs.dart';

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  MovieDetailState loadedState({bool isAddedToWatchlist = false}) {
    return MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.loaded,
      isAddedToWatchlist: isAddedToWatchlist,
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(loadedState());

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
    (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(loadedState(isAddedToWatchlist: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
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

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      verify(() => mockBloc.add(AddMovieToWatchlist(testMovieDetail)))
          .called(1);
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

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
