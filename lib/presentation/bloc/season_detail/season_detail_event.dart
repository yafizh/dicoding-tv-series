part of 'season_detail_bloc.dart';

sealed class SeasonDetailEvent extends Equatable {
  const SeasonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonDetail extends SeasonDetailEvent {
  final int tvId;
  final int seasonNumber;

  const FetchSeasonDetail(this.tvId, this.seasonNumber);

  @override
  List<Object> get props => [tvId, seasonNumber];
}
