import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/usecases/get_movie_detail.dart';
import 'package:tv_series/domain/usecases/get_movie_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist.dart';
import 'package:tv_series/domain/usecases/save_watchlist.dart';
import 'package:tv_series/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(bloc.state, const MovieDetailState());
  });

  group('Fetch Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit the detail and recommendations when data is gotten '
      'successfully',
      setUp: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          recommendations: testMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit a recommendation error when only the recommendations fail',
      setUp: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit an error when the detail is unsuccessful',
      setUp: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.loading),
        const MovieDetailState(
          movieState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit the watchlist status',
      setUp: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [const MovieDetailState(isAddedToWatchlist: true)],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should save to watchlist and emit the success message and new status',
      setUp: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(),
        const MovieDetailState(
          isAddedToWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(testMovieDetail));
        verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should remove from watchlist and emit the success message and new '
      'status',
      setUp: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
      },
      build: () => bloc,
      seed: () => const MovieDetailState(isAddedToWatchlist: true),
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ],
      verify: (_) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should clear the previous message so a repeated failure is emitted '
      'again',
      setUp: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
      },
      build: () => bloc,
      seed: () => const MovieDetailState(watchlistMessage: 'Failed'),
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        const MovieDetailState(),
        const MovieDetailState(watchlistMessage: 'Failed'),
      ],
    );
  });
}
