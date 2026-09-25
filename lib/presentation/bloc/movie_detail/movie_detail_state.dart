part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final RequestState movieState;
  final MovieDetail? movie;
  final RequestState recommendationState;
  final List<Movie> recommendations;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movieState = RequestState.empty,
    this.movie,
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    RequestState? movieState,
    MovieDetail? movie,
    RequestState? recommendationState,
    List<Movie>? recommendations,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      movie: movie ?? this.movie,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movieState,
    movie,
    recommendationState,
    recommendations,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
