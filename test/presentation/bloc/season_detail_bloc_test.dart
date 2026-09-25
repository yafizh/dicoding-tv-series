import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';
import 'package:tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVSeasonDetail])
void main() {
  late SeasonDetailBloc bloc;
  late MockGetTVSeasonDetail mockGetTVSeasonDetail;

  setUp(() {
    mockGetTVSeasonDetail = MockGetTVSeasonDetail();
    bloc = SeasonDetailBloc(mockGetTVSeasonDetail);
  });

  const tId = 1399;
  const tSeasonNumber = 1;

  test('initial state should be empty', () {
    expect(bloc.state, const SeasonDetailEmpty());
  });

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    setUp: () {
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Right(testSeasonDetail));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchSeasonDetail(tId, tSeasonNumber)),
    expect: () => [
      const SeasonDetailLoading(),
      SeasonDetailHasData(testSeasonDetail),
    ],
    verify: (_) => verify(mockGetTVSeasonDetail.execute(tId, tSeasonNumber)),
  );

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    setUp: () {
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchSeasonDetail(tId, tSeasonNumber)),
    expect: () => [
      const SeasonDetailLoading(),
      const SeasonDetailError('Server Failure'),
    ],
  );
}
