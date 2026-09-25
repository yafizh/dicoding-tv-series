import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/usecases/search_tvs.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTVs])
void main() {
  late TVSearchBloc bloc;
  late MockSearchTVs mockSearchTVs;

  setUp(() {
    mockSearchTVs = MockSearchTVs();
    bloc = TVSearchBloc(mockSearchTVs);
  });

  const tQuery = 'game of thrones';

  test('initial state should be empty', () {
    expect(bloc.state, const TVListEmpty());
  });

  blocTest<TVSearchBloc, TVListState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    setUp: () {
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Right(testTVList));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    expect: () => [const TVListLoading(), TVListHasData(testTVList)],
    verify: (_) => verify(mockSearchTVs.execute(tQuery)),
  );

  blocTest<TVSearchBloc, TVListState>(
    'should emit [Loading, Error] when search is unsuccessful',
    setUp: () {
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    expect: () => [const TVListLoading(), const TVListError('Server Failure')],
    verify: (_) => verify(mockSearchTVs.execute(tQuery)),
  );
}
