import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/usecases/get_now_playing_movies.dart';
import 'package:tv_series/domain/usecases/get_popular_movies.dart';
import 'package:tv_series/domain/usecases/get_top_rated_movies.dart';
import 'package:tv_series/domain/usecases/get_watchlist_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

/// Loads a single list of movies. Each subclass only decides which use case
/// the list comes from, so every movie list in the app shares one set of
/// events and states.
abstract class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc() : super(const MovieListEmpty()) {
    on<FetchMovieList>((_, emit) async {
      emit(const MovieListLoading());

      final result = await fetchMovies();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }

  Future<Either<Failure, List<Movie>>> fetchMovies();
}

class NowPlayingMoviesBloc extends MovieListBloc {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies);

  @override
  Future<Either<Failure, List<Movie>>> fetchMovies() {
    return getNowPlayingMovies.execute();
  }
}

class PopularMoviesBloc extends MovieListBloc {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies);

  @override
  Future<Either<Failure, List<Movie>>> fetchMovies() {
    return getPopularMovies.execute();
  }
}

class TopRatedMoviesBloc extends MovieListBloc {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies);

  @override
  Future<Either<Failure, List<Movie>>> fetchMovies() {
    return getTopRatedMovies.execute();
  }
}

class WatchlistMoviesBloc extends MovieListBloc {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies);

  @override
  Future<Either<Failure, List<Movie>>> fetchMovies() {
    return getWatchlistMovies.execute();
  }
}
