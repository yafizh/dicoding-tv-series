import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/usecases/search_tvs.dart';
import 'package:tv_series/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVs])
void main() {
  late TVSearchNotifier provider;
  late MockSearchTVs mockSearchTVs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVs = MockSearchTVs();
    provider = TVSearchNotifier(searchTVs: mockSearchTVs)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTV = TV(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTVList = <TV>[tTV];
  final tQuery = 'game of thrones';

  group('search tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Right(tTVList));
      // act
      provider.fetchTVSearch(tQuery);
      // assert
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        // arrange
        when(mockSearchTVs.execute(tQuery))
            .thenAnswer((_) async => Right(tTVList));
        // act
        await provider.fetchTVSearch(tQuery);
        // assert
        expect(provider.state, RequestState.loaded);
        expect(provider.searchResult, tTVList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVSearch(tQuery);
      // assert
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
