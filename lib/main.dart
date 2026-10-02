import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/utils.dart';
import 'package:tv_series/firebase_options.dart';
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
import 'package:tv_series/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv_series/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTVsBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVsBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVsBloc>()),
        BlocProvider(create: (_) => di.locator<TVSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TVDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SeasonDetailBloc>()),
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
