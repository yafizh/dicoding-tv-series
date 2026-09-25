import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/pages/watchlist_tvs_page.dart';
import 'package:tv_series/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tvs_page_test.mocks.dart';

@GenerateMocks([WatchlistTVNotifier])
void main() {
  late MockWatchlistTVNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTVNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistTVs).thenReturn(<TV>[]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display saved tv series', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistTVs).thenReturn(<TV>[testWatchlistTV]);

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(find.text('name'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(WatchlistTVsPage()));

    expect(textFinder, findsOneWidget);
  });
}
