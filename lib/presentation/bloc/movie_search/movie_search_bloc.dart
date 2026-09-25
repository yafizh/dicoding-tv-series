import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/search_movies.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';

part 'movie_search_event.dart';

/// Search results are just another list of movies, so this bloc reuses the
/// [MovieListState]s.
class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieListState> {
  final SearchMovies searchMovies;

  MovieSearchBloc(this.searchMovies) : super(const MovieListEmpty()) {
    on<FetchMovieSearch>((event, emit) async {
      emit(const MovieListLoading());

      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (movies) => emit(MovieListHasData(movies)),
      );
    });
  }
}
