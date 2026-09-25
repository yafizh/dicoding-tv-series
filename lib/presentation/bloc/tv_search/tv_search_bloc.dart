import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/usecases/search_tvs.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';

part 'tv_search_event.dart';

/// Search results are just another list of TV series, so this bloc reuses the
/// [TVListState]s.
class TVSearchBloc extends Bloc<TVSearchEvent, TVListState> {
  final SearchTVs searchTVs;

  TVSearchBloc(this.searchTVs) : super(const TVListEmpty()) {
    on<FetchTVSearch>((event, emit) async {
      emit(const TVListLoading());

      final result = await searchTVs.execute(event.query);
      result.fold(
        (failure) => emit(TVListError(failure.message)),
        (tvs) => emit(TVListHasData(tvs)),
      );
    });
  }
}
