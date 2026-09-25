import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchListTVStatus getWatchListStatus;
  final SaveWatchlistTV saveWatchlist;
  final RemoveWatchlistTV removeWatchlist;

  TVDetailBloc({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TVDetailState()) {
    on<FetchTVDetail>(_onFetchTVDetail);
    on<LoadTVWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddTVToWatchlist>(_onAddToWatchlist);
    on<RemoveTVFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchTVDetail(
    FetchTVDetail event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(state.copyWith(tvState: RequestState.loading));

    final detailResult = await getTVDetail.execute(event.id);
    final recommendationResult = await getTVRecommendations.execute(event.id);
    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(tvState: RequestState.error, message: failure.message),
        );
      },
      (tv) {
        final loaded = state.copyWith(tvState: RequestState.loaded, tv: tv);
        recommendationResult.fold(
          (failure) {
            emit(
              loaded.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ),
            );
          },
          (tvs) {
            emit(
              loaded.copyWith(
                recommendationState: RequestState.loaded,
                recommendations: tvs,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadTVWatchlistStatus event,
    Emitter<TVDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: isAdded));
  }

  Future<void> _onAddToWatchlist(
    AddTVToWatchlist event,
    Emitter<TVDetailState> emit,
  ) async {
    // Clear the previous message first so that the same message coming back
    // twice in a row is still seen as a new state by listeners.
    emit(state.copyWith(watchlistMessage: ''));

    final result = await saveWatchlist.execute(event.tv);
    final message = result.fold((failure) => failure.message, (m) => m);
    final isAdded = await getWatchListStatus.execute(event.tv.id);
    emit(
      state.copyWith(watchlistMessage: message, isAddedToWatchlist: isAdded),
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveTVFromWatchlist event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(state.copyWith(watchlistMessage: ''));

    final result = await removeWatchlist.execute(event.tv);
    final message = result.fold((failure) => failure.message, (m) => m);
    final isAdded = await getWatchListStatus.execute(event.tv.id);
    emit(
      state.copyWith(watchlistMessage: message, isAddedToWatchlist: isAdded),
    );
  }
}
