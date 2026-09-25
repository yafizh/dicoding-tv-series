part of 'tv_list_bloc.dart';

sealed class TVListEvent extends Equatable {
  const TVListEvent();

  @override
  List<Object> get props => [];
}

class FetchTVList extends TVListEvent {
  const FetchTVList();
}
