import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tvs.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

/// Loads a single list of TV series. Each subclass only decides which use case
/// the list comes from, so every TV series list in the app shares one set of
/// events and states.
abstract class TVListBloc extends Bloc<TVListEvent, TVListState> {
  TVListBloc() : super(const TVListEmpty()) {
    on<FetchTVList>((_, emit) async {
      emit(const TVListLoading());

      final result = await fetchTVs();
      result.fold(
        (failure) => emit(TVListError(failure.message)),
        (tvs) => emit(TVListHasData(tvs)),
      );
    });
  }

  Future<Either<Failure, List<TV>>> fetchTVs();
}

class OnTheAirTVsBloc extends TVListBloc {
  final GetOnTheAirTVs getOnTheAirTVs;

  OnTheAirTVsBloc(this.getOnTheAirTVs);

  @override
  Future<Either<Failure, List<TV>>> fetchTVs() {
    return getOnTheAirTVs.execute();
  }
}

class PopularTVsBloc extends TVListBloc {
  final GetPopularTVs getPopularTVs;

  PopularTVsBloc(this.getPopularTVs);

  @override
  Future<Either<Failure, List<TV>>> fetchTVs() {
    return getPopularTVs.execute();
  }
}

class TopRatedTVsBloc extends TVListBloc {
  final GetTopRatedTVs getTopRatedTVs;

  TopRatedTVsBloc(this.getTopRatedTVs);

  @override
  Future<Either<Failure, List<TV>>> fetchTVs() {
    return getTopRatedTVs.execute();
  }
}

class WatchlistTVsBloc extends TVListBloc {
  final GetWatchlistTVs getWatchlistTVs;

  WatchlistTVsBloc(this.getWatchlistTVs);

  @override
  Future<Either<Failure, List<TV>>> fetchTVs() {
    return getWatchlistTVs.execute();
  }
}
