import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/usecases/search_movies.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_search/movie_search_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(mockSearchMovies);
  });

  const tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(bloc.state, const MovieListEmpty());
  });

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    setUp: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
    expect: () => [const MovieListLoading(), MovieListHasData(testMovieList)],
    verify: (_) => verify(mockSearchMovies.execute(tQuery)),
  );

  blocTest<MovieSearchBloc, MovieListState>(
    'should emit [Loading, Error] when search is unsuccessful',
    setUp: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
    expect: () => [
      const MovieListLoading(),
      const MovieListError('Server Failure'),
    ],
    verify: (_) => verify(mockSearchMovies.execute(tQuery)),
  );
}
