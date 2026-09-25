import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';
import 'package:tv_series/presentation/provider/season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'season_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTVSeasonDetail])
void main() {
  late SeasonDetailNotifier provider;
  late MockGetTVSeasonDetail mockGetTVSeasonDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVSeasonDetail = MockGetTVSeasonDetail();
    provider = SeasonDetailNotifier(getTVSeasonDetail: mockGetTVSeasonDetail)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;
  final tSeasonNumber = 1;

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    provider.fetchSeasonDetail(tId, tSeasonNumber);
    // assert
    expect(provider.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test(
    'should change season detail when data is gotten successfully',
    () async {
      // arrange
      when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Right(testSeasonDetail));
      // act
      await provider.fetchSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(provider.state, RequestState.loaded);
      expect(provider.seasonDetail, testSeasonDetail);
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTVSeasonDetail.execute(tId, tSeasonNumber))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchSeasonDetail(tId, tSeasonNumber);
    // assert
    expect(provider.state, RequestState.error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
