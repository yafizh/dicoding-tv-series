import 'package:tv_series/data/datasources/movie_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_local_data_source.dart';
import 'package:tv_series/injection.dart' as di;
import 'package:tv_series/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

import 'fake_data_sources.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.locator.reset();
    di.init();

    // Swap the two edges of the app - the network and the database - for
    // deterministic doubles, so the rest of the stack runs for real.
    di.locator.unregister<http.Client>();
    di.locator.registerLazySingleton<http.Client>(() => createFakeTmdbClient());
    di.locator.unregister<MovieLocalDataSource>();
    di.locator.registerLazySingleton<MovieLocalDataSource>(
      () => InMemoryMovieLocalDataSource(),
    );
    di.locator.unregister<TVLocalDataSource>();
    di.locator.registerLazySingleton<TVLocalDataSource>(
      () => InMemoryTVLocalDataSource(),
    );
  });

  /// Poster images never resolve in tests, so their placeholder spinners keep
  /// the tree busy forever - pump by hand instead of using pumpAndSettle.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> openTVHome(WidgetTester tester) async {
    await tester.pumpWidget(app.MyApp());
    await settle(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await settle(tester);
    await tester.tap(find.byKey(const Key('drawer_tv_series')));
    await settle(tester);
  }

  Future<void> openFirstPopularTVDetail(WidgetTester tester) async {
    await tester.tap(find.text('See More').first);
    await settle(tester);
    expect(find.text('Popular TV Series'), findsOneWidget);

    await tester.tap(find.text('Stranger Things'));
    await settle(tester);
  }

  testWidgets('starts on the movie page and navigates to the TV series page', (
    tester,
  ) async {
    await tester.pumpWidget(app.MyApp());
    await settle(tester);

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await settle(tester);
    await tester.tap(find.byKey(const Key('drawer_tv_series')));
    await settle(tester);

    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('opens a TV series detail with its seasons and episodes', (
    tester,
  ) async {
    await openTVHome(tester);
    await openFirstPopularTVDetail(tester);

    expect(find.text('Game of Thrones'), findsOneWidget);
    expect(find.text('8 Season(s) \u2022 73 Episode(s)'), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);

    await tester.ensureVisible(find.text('Season 1'));
    await settle(tester);
    await tester.tap(find.text('Season 1'));
    await settle(tester);

    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('E1 \u2022 Winter Is Coming'), findsOneWidget);
  });

  testWidgets('searches TV series by title', (tester) async {
    await openTVHome(tester);

    await tester.tap(find.byIcon(Icons.search));
    await settle(tester);
    expect(find.text('Search TV Series'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('query_input')), 'game');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await settle(tester);

    expect(find.text('Game of Thrones'), findsOneWidget);
  });

  testWidgets('adds a TV series to the watchlist and lists it again', (
    tester,
  ) async {
    await openTVHome(tester);
    await openFirstPopularTVDetail(tester);

    await tester.tap(find.byKey(const Key('watchlist_button')));
    await settle(tester);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);

    // Back to the popular list, then back to the TV home page.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await settle(tester);
    await tester.pageBack();
    await settle(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await settle(tester);
    await tester.tap(find.byKey(const Key('drawer_watchlist_tvs')));
    await settle(tester);

    expect(find.text('Watchlist TV Series'), findsOneWidget);
    expect(find.text('Game of Thrones'), findsOneWidget);
  });
}
