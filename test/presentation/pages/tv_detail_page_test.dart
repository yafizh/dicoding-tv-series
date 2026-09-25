import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TVDetailNotifier])
void main() {
  late MockTVDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  void arrangeLoadedDetail({bool isAddedToWatchlist = false}) {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(isAddedToWatchlist);
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'Page should display the title, rating and overview when loaded',
    (WidgetTester tester) async {
      arrangeLoadedDetail();

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.text('name'), findsOneWidget);
      expect(find.text('overview'), findsWidgets);
      expect(find.text('${testTVDetail.voteAverage}'), findsOneWidget);
    },
  );

  testWidgets('Page should display the season and episode information', (
    WidgetTester tester,
  ) async {
    arrangeLoadedDetail();

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
    arrangeLoadedDetail();

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byKey(Key('recommendation_list')), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      arrangeLoadedDetail(isAddedToWatchlist: false);

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      arrangeLoadedDetail(isAddedToWatchlist: true);

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      arrangeLoadedDetail(isAddedToWatchlist: false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
      await tester.tap(find.byKey(Key('watchlist_button')));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      arrangeLoadedDetail(isAddedToWatchlist: false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

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
    when(mockNotifier.tvState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.text('Server Failure'), findsOneWidget);
  });
}
