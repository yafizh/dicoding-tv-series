part of 'tv_detail_bloc.dart';

sealed class TVDetailEvent extends Equatable {
  const TVDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVDetail extends TVDetailEvent {
  final int id;

  const FetchTVDetail(this.id);

  @override
  List<Object> get props => [id];
}

class LoadTVWatchlistStatus extends TVDetailEvent {
  final int id;

  const LoadTVWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddTVToWatchlist extends TVDetailEvent {
  final TVDetail tv;

  const AddTVToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTVFromWatchlist extends TVDetailEvent {
  final TVDetail tv;

  const RemoveTVFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
