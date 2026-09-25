import 'package:tv_series/common/ssl_pinning.dart';
import 'package:tv_series/data/datasources/db/database_helper.dart';
import 'package:tv_series/data/datasources/movie_local_data_source.dart';
import 'package:tv_series/data/datasources/movie_remote_data_source.dart';
import 'package:tv_series/data/datasources/tv_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_remote_data_source.dart';
import 'package:tv_series/data/repositories/movie_repository_impl.dart';
import 'package:tv_series/data/repositories/tv_repository_impl.dart';
import 'package:tv_series/domain/repositories/movie_repository.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';
import 'package:tv_series/domain/usecases/get_movie_detail.dart';
import 'package:tv_series/domain/usecases/get_movie_recommendations.dart';
import 'package:tv_series/domain/usecases/get_now_playing_movies.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv_series/domain/usecases/get_popular_movies.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';
import 'package:tv_series/domain/usecases/get_top_rated_movies.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';
import 'package:tv_series/domain/usecases/get_watchlist_movies.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/search_movies.dart';
import 'package:tv_series/domain/usecases/search_tvs.dart';
import 'package:tv_series/presentation/provider/movie_detail_notifier.dart';
import 'package:tv_series/presentation/provider/movie_list_notifier.dart';
import 'package:tv_series/presentation/provider/movie_search_notifier.dart';
import 'package:tv_series/presentation/provider/popular_movies_notifier.dart';
import 'package:tv_series/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/season_detail_notifier.dart';
import 'package:tv_series/presentation/provider/top_rated_movies_notifier.dart';
import 'package:tv_series/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv_series/presentation/provider/tv_detail_notifier.dart';
import 'package:tv_series/presentation/provider/tv_list_notifier.dart';
import 'package:tv_series/presentation/provider/tv_search_notifier.dart';
import 'package:tv_series/presentation/provider/watchlist_movie_notifier.dart';
import 'package:tv_series/presentation/provider/watchlist_tv_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(() {
    return MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    );
  });
  locator.registerFactory(() {
    return MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    );
  });
  locator.registerFactory(() => MovieSearchNotifier(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesNotifier(locator()));
  locator.registerFactory(
    () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(getWatchlistMovies: locator()),
  );
  locator.registerFactory(() {
    return TVListNotifier(
      getOnTheAirTVs: locator(),
      getPopularTVs: locator(),
      getTopRatedTVs: locator(),
    );
  });
  locator.registerFactory(() {
    return TVDetailNotifier(
      getTVDetail: locator(),
      getTVRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    );
  });
  locator.registerFactory(() => TVSearchNotifier(searchTVs: locator()));
  locator.registerFactory(() => OnTheAirTVsNotifier(locator()));
  locator.registerFactory(() => PopularTVsNotifier(locator()));
  locator.registerFactory(() => TopRatedTVsNotifier(getTopRatedTVs: locator()));
  locator.registerFactory(
    () => WatchlistTVNotifier(getWatchlistTVs: locator()),
  );
  locator.registerFactory(
    () => SeasonDetailNotifier(getTVSeasonDetail: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTVs(locator()));
  locator.registerLazySingleton(() => GetPopularTVs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVs(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => GetTVSeasonDetail(locator()));
  locator.registerLazySingleton(() => SearchTVs(locator()));
  locator.registerLazySingleton(() => GetWatchListTVStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTV(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTV(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVs(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(() {
    return MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    );
  });
  locator.registerLazySingleton<TVRepository>(() {
    return TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    );
  });

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TVRemoteDataSource>(
    () => TVRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TVLocalDataSource>(
    () => TVLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton<http.Client>(() => SslPinningClient());
}
