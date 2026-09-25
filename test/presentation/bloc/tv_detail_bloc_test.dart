import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/usecases/get_tv_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailBloc bloc;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListTVStatus mockGetWatchlistStatus;
  late MockSaveWatchlistTV mockSaveWatchlist;
  late MockRemoveWatchlistTV mockRemoveWatchlist;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchlistStatus = MockGetWatchListTVStatus();
    mockSaveWatchlist = MockSaveWatchlistTV();
    mockRemoveWatchlist = MockRemoveWatchlistTV();
    bloc = TVDetailBloc(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(bloc.state, const TVDetailState());
  });

  group('Fetch TV Detail', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'should emit the detail and recommendations when data is gotten '
      'successfully',
      setUp: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVDetail));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTVList));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        const TVDetailState(tvState: RequestState.loading),
        TVDetailState(
          tvState: RequestState.loaded,
          tv: testTVDetail,
          recommendationState: RequestState.loaded,
          recommendations: testTVList,
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should emit a recommendation error when only the recommendations fail',
      setUp: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVDetail));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        const TVDetailState(tvState: RequestState.loading),
        TVDetailState(
          tvState: RequestState.loaded,
          tv: testTVDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should emit an error when the detail is unsuccessful',
      setUp: () {
        when(mockGetTVDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTVList));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        const TVDetailState(tvState: RequestState.loading),
        const TVDetailState(
          tvState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'should emit the watchlist status',
      setUp: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadTVWatchlistStatus(tId)),
      expect: () => [const TVDetailState(isAddedToWatchlist: true)],
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should save to watchlist and emit the success message and new status',
      setUp: () {
        when(mockSaveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => true);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(AddTVToWatchlist(testTVDetail)),
      expect: () => [
        const TVDetailState(),
        const TVDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testTVDetail));
        verify(mockGetWatchlistStatus.execute(testTVDetail.id));
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should remove from watchlist and emit the success message and new '
      'status',
      setUp: () {
        when(mockRemoveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
      },
      build: () => bloc,
      seed: () => const TVDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveTVFromWatchlist(testTVDetail)),
      expect: () => [
        const TVDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(testTVDetail)),
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should clear the previous message so a repeated failure is emitted '
      'again',
      setUp: () {
        when(mockSaveWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
      },
      build: () => bloc,
      seed: () => const TVDetailState(watchlistMessage: 'Failed'),
      act: (bloc) => bloc.add(AddTVToWatchlist(testTVDetail)),
      expect: () => [
        const TVDetailState(),
        const TVDetailState(watchlistMessage: 'Failed'),
      ],
    );
  });
}
