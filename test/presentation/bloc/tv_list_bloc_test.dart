import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTVs, GetPopularTVs, GetTopRatedTVs, GetWatchlistTVs])
void main() {
  late MockGetOnTheAirTVs mockGetOnTheAirTVs;
  late MockGetPopularTVs mockGetPopularTVs;
  late MockGetTopRatedTVs mockGetTopRatedTVs;
  late MockGetWatchlistTVs mockGetWatchlistTVs;

  setUp(() {
    mockGetOnTheAirTVs = MockGetOnTheAirTVs();
    mockGetPopularTVs = MockGetPopularTVs();
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    mockGetWatchlistTVs = MockGetWatchlistTVs();
  });

  /// Every [TVListBloc] behaves the same, only the use case differs.
  void testTVListBloc(
    String description,
    TVListBloc Function() build,
    Future<Either<Failure, List<TV>>> Function() execute,
  ) {
    group(description, () {
      test('initial state should be empty', () {
        expect(build().state, const TVListEmpty());
      });

      blocTest<TVListBloc, TVListState>(
        'should emit [Loading, HasData] when data is gotten successfully',
        setUp: () {
          when(execute()).thenAnswer((_) async => Right(testTVList));
        },
        build: build,
        act: (bloc) => bloc.add(const FetchTVList()),
        expect: () => [const TVListLoading(), TVListHasData(testTVList)],
        verify: (_) => verify(execute()),
      );

      blocTest<TVListBloc, TVListState>(
        'should emit [Loading, Error] when get data is unsuccessful',
        setUp: () {
          when(execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        },
        build: build,
        act: (bloc) => bloc.add(const FetchTVList()),
        expect: () => [
          const TVListLoading(),
          const TVListError('Server Failure'),
        ],
        verify: (_) => verify(execute()),
      );
    });
  }

  testTVListBloc(
    'OnTheAirTVsBloc',
    () => OnTheAirTVsBloc(mockGetOnTheAirTVs),
    () => mockGetOnTheAirTVs.execute(),
  );
  testTVListBloc(
    'PopularTVsBloc',
    () => PopularTVsBloc(mockGetPopularTVs),
    () => mockGetPopularTVs.execute(),
  );
  testTVListBloc(
    'TopRatedTVsBloc',
    () => TopRatedTVsBloc(mockGetTopRatedTVs),
    () => mockGetTopRatedTVs.execute(),
  );
  testTVListBloc(
    'WatchlistTVsBloc',
    () => WatchlistTVsBloc(mockGetWatchlistTVs),
    () => mockGetWatchlistTVs.execute(),
  );
}
