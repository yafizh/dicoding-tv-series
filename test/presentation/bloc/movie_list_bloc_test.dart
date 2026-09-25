import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/usecases/get_now_playing_movies.dart';
import 'package:tv_series/domain/usecases/get_popular_movies.dart';
import 'package:tv_series/domain/usecases/get_top_rated_movies.dart';
import 'package:tv_series/domain/usecases/get_watchlist_movies.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetWatchlistMovies,
])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetWatchlistMovies = MockGetWatchlistMovies();
  });

  /// Every [MovieListBloc] behaves the same, only the use case differs.
  void testMovieListBloc(
    String description,
    MovieListBloc Function() build,
    Future<Either<Failure, List<Movie>>> Function() execute,
  ) {
    group(description, () {
      test('initial state should be empty', () {
        expect(build().state, const MovieListEmpty());
      });

      blocTest<MovieListBloc, MovieListState>(
        'should emit [Loading, HasData] when data is gotten successfully',
        setUp: () {
          when(execute()).thenAnswer((_) async => Right(testMovieList));
        },
        build: build,
        act: (bloc) => bloc.add(const FetchMovieList()),
        expect: () => [
          const MovieListLoading(),
          MovieListHasData(testMovieList),
        ],
        verify: (_) => verify(execute()),
      );

      blocTest<MovieListBloc, MovieListState>(
        'should emit [Loading, Error] when get data is unsuccessful',
        setUp: () {
          when(execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        },
        build: build,
        act: (bloc) => bloc.add(const FetchMovieList()),
        expect: () => [
          const MovieListLoading(),
          const MovieListError('Server Failure'),
        ],
        verify: (_) => verify(execute()),
      );
    });
  }

  testMovieListBloc(
    'NowPlayingMoviesBloc',
    () => NowPlayingMoviesBloc(mockGetNowPlayingMovies),
    () => mockGetNowPlayingMovies.execute(),
  );
  testMovieListBloc(
    'PopularMoviesBloc',
    () => PopularMoviesBloc(mockGetPopularMovies),
    () => mockGetPopularMovies.execute(),
  );
  testMovieListBloc(
    'TopRatedMoviesBloc',
    () => TopRatedMoviesBloc(mockGetTopRatedMovies),
    () => mockGetTopRatedMovies.execute(),
  );
  testMovieListBloc(
    'WatchlistMoviesBloc',
    () => WatchlistMoviesBloc(mockGetWatchlistMovies),
    () => mockGetWatchlistMovies.execute(),
  );
}
