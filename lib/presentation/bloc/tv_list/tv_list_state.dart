part of 'tv_list_bloc.dart';

sealed class TVListState extends Equatable {
  const TVListState();

  @override
  List<Object> get props => [];
}

class TVListEmpty extends TVListState {
  const TVListEmpty();
}

class TVListLoading extends TVListState {
  const TVListLoading();
}

class TVListHasData extends TVListState {
  final List<TV> tvs;

  const TVListHasData(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class TVListError extends TVListState {
  final String message;

  const TVListError(this.message);

  @override
  List<Object> get props => [message];
}
