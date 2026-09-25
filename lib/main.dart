import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/utils.dart';
import 'package:tv_series/presentation/pages/about_page.dart';
import 'package:tv_series/presentation/pages/home_movie_page.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:tv_series/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv_series/presentation/pages/popular_movies_page.dart';
import 'package:tv_series/presentation/pages/popular_tvs_page.dart';
import 'package:tv_series/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/search_tv_page.dart';
import 'package:tv_series/presentation/pages/season_detail_page.dart';
import 'package:tv_series/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tvs_page.dart';
import 'package:tv_series/presentation/provider/movie_detail_notifier.dart';
import 'package:tv_series/presentation/provider/movie_list_notifier.dart';
import 'package:tv_series/presentation/provider/movie_search_notifier.dart';
import 'package:tv_series/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/popular_movies_notifier.dart';
import 'package:tv_series/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/season_detail_notifier.dart';
import 'package:tv_series/presentation/provider/top_rated_movies_notifier.dart';
import 'package:tv_series/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/tv_detail_notifier.dart';
import 'package:tv_series/presentation/provider/tv_list_notifier.dart';
import 'package:tv_series/presentation/provider/tv_search_notifier.dart';
import 'package:tv_series/presentation/provider/watchlist_movie_notifier.dart';
import 'package:tv_series/presentation/provider/watchlist_tv_notifier.dart';
import 'package:tv_series/injection.dart' as di;
import 'package:provider/provider.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<TVListNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TVDetailNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TVSearchNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTVsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<OnTheAirTVsNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<PopularTVsNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTVNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeasonDetailNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: colorScheme,
          primaryColor: richBlack,
          scaffoldBackgroundColor: richBlack,
          textTheme: textTheme,
          drawerTheme: drawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case HomeTVPage.routeName:
              return MaterialPageRoute(builder: (_) => HomeTVPage());
            case OnTheAirTVsPage.routeName:
              return CupertinoPageRoute(builder: (_) => OnTheAirTVsPage());
            case PopularTVsPage.routeName:
              return CupertinoPageRoute(builder: (_) => PopularTVsPage());
            case TopRatedTVsPage.routeName:
              return CupertinoPageRoute(builder: (_) => TopRatedTVsPage());
            case TVDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case SeasonDetailPage.routeName:
              final args = settings.arguments as SeasonDetailPageArgs;
              return MaterialPageRoute(
                builder: (_) {
                  return SeasonDetailPage(
                    tvId: args.tvId,
                    seasonNumber: args.seasonNumber,
                  );
                },
                settings: settings,
              );
            case SearchTVPage.routeName:
              return CupertinoPageRoute(builder: (_) => SearchTVPage());
            case WatchlistTVsPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistTVsPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
