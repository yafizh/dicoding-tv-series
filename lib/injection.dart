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
import 'package:tv_series/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(() => WatchlistMoviesBloc(locator()));
  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator.registerFactory(() {
    return MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    );
  });
  locator.registerFactory(() => OnTheAirTVsBloc(locator()));
  locator.registerFactory(() => PopularTVsBloc(locator()));
  locator.registerFactory(() => TopRatedTVsBloc(locator()));
  locator.registerFactory(() => WatchlistTVsBloc(locator()));
  locator.registerFactory(() => TVSearchBloc(locator()));
  locator.registerFactory(() {
    return TVDetailBloc(
      getTVDetail: locator(),
      getTVRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    );
  });
  locator.registerFactory(() => SeasonDetailBloc(locator()));

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
