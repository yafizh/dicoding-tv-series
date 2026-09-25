part of 'tv_detail_bloc.dart';

class TVDetailState extends Equatable {
  final RequestState tvState;
  final TVDetail? tv;
  final RequestState recommendationState;
  final List<TV> recommendations;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TVDetailState({
    this.tvState = RequestState.empty,
    this.tv,
    this.recommendationState = RequestState.empty,
    this.recommendations = const [],
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TVDetailState copyWith({
    RequestState? tvState,
    TVDetail? tv,
    RequestState? recommendationState,
    List<TV>? recommendations,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TVDetailState(
      tvState: tvState ?? this.tvState,
      tv: tv ?? this.tv,
      recommendationState: recommendationState ?? this.recommendationState,
      recommendations: recommendations ?? this.recommendations,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvState,
    tv,
    recommendationState,
    recommendations,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
