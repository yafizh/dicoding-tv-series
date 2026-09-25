import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/entities/movie_detail.dart';
import 'package:tv_series/domain/usecases/get_movie_detail.dart';
import 'package:tv_series/domain/usecases/get_movie_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddMovieToWatchlist>(_onAddToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.loading));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );
    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(
            movieState: RequestState.error,
            message: failure.message,
          ),
        );
      },
      (movie) {
        final loaded = state.copyWith(
          movieState: RequestState.loaded,
          movie: movie,
        );
        recommendationResult.fold(
          (failure) {
            emit(
              loaded.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ),
            );
          },
          (movies) {
            emit(
              loaded.copyWith(
                recommendationState: RequestState.loaded,
                recommendations: movies,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: isAdded));
  }

  Future<void> _onAddToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    // Clear the previous message first so that the same message coming back
    // twice in a row is still seen as a new state by listeners.
    emit(state.copyWith(watchlistMessage: ''));

    final result = await saveWatchlist.execute(event.movie);
    final message = result.fold((failure) => failure.message, (m) => m);
    final isAdded = await getWatchListStatus.execute(event.movie.id);
    emit(
      state.copyWith(watchlistMessage: message, isAddedToWatchlist: isAdded),
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));

    final result = await removeWatchlist.execute(event.movie);
    final message = result.fold((failure) => failure.message, (m) => m);
    final isAdded = await getWatchListStatus.execute(event.movie.id);
    emit(
      state.copyWith(watchlistMessage: message, isAddedToWatchlist: isAdded),
    );
  }
}
