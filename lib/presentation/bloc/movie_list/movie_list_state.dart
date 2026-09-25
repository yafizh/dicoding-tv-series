part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListEmpty extends MovieListState {
  const MovieListEmpty();
}

class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

class MovieListHasData extends MovieListState {
  final List<Movie> movies;

  const MovieListHasData(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieListError extends MovieListState {
  final String message;

  const MovieListError(this.message);

  @override
  List<Object> get props => [message];
}
