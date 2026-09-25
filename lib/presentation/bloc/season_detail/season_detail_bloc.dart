import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';

part 'season_detail_event.dart';
part 'season_detail_state.dart';

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final GetTVSeasonDetail getTVSeasonDetail;

  SeasonDetailBloc(this.getTVSeasonDetail) : super(const SeasonDetailEmpty()) {
    on<FetchSeasonDetail>((event, emit) async {
      emit(const SeasonDetailLoading());

      final result = await getTVSeasonDetail.execute(
        event.tvId,
        event.seasonNumber,
      );
      result.fold(
        (failure) => emit(SeasonDetailError(failure.message)),
        (seasonDetail) => emit(SeasonDetailHasData(seasonDetail)),
      );
    });
  }
}
