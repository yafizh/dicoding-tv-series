import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tv_series/common/exception.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/data/models/genre_model.dart';
import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/data/models/tv_detail_model.dart';
import 'package:tv_series/data/models/tv_model.dart';
import 'package:tv_series/data/repositories/tv_repository_impl.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVModel(
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

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  final tTVDetailResponse = TVDetailResponse(
    backdropPath: 'backdropPath',
    episodeRunTime: [60],
    firstAirDate: 'firstAirDate',
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'homepage',
    id: 1,
    name: 'name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    seasons: [
      SeasonModel(
        airDate: 'airDate',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      ),
    ],
    status: 'Ended',
    tagline: 'tagline',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeasonDetailResponse = SeasonDetailResponse(
    airDate: 'airDate',
    episodes: [
      EpisodeModel(
        airDate: 'airDate',
        episodeNumber: 1,
        id: 1,
        name: 'Winter Is Coming',
        overview: 'overview',
        runtime: 62,
        seasonNumber: 1,
        stillPath: 'stillPath',
        voteAverage: 7.6,
      ),
    ],
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  group('On The Air TVs', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTVs())
            .thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.getOnTheAirTVs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTVs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTVs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTVs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTVs());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test('should return connection failure when the device is not connected to internet', () async {
      // arrange
      when(mockRemoteDataSource.getOnTheAirTVs())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getOnTheAirTVs();
      // assert
      verify(mockRemoteDataSource.getOnTheAirTVs());
      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Popular TVs', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTVs())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTVs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTVs()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTVs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTVs())
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTVs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TVs', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTVs())
            .thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.getTopRatedTVs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTVs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTVs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTVs())
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTVs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Detail', () {
    final tId = 1;

    test(
      'should return TV data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVDetail(tId))
            .thenAnswer((_) async => tTVDetailResponse);
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVDetail(tId));
        expect(result, equals(Right(testTVDetail)));
      },
    );

    test(
      'should return Server Failure when the call is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVDetail(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Recommendations', () {
    final tId = 1;

    test('should return data when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
      'should return server failure when the call is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVRecommendations(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTVRecommendations(tId);
        // assert
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVRecommendations(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVRecommendations(tId);
        // assert
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Season Detail', () {
    final tId = 1;
    final tSeasonNumber = 1;

    test('should return season detail when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
          .thenAnswer((_) async => tSeasonDetailResponse);
      // act
      final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
      // assert
      verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
      expect(result, equals(Right(testSeasonDetail)));
    });

    test(
      'should return server failure when the call is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Search TVs', () {
    final tQuery = 'game of thrones';

    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTVs(tQuery))
            .thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.searchTVs(tQuery);
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTVs(tQuery))
            .thenThrow(ServerException());
        // act
        final result = await repository.searchTVs(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTVs(tQuery))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTVs(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving is successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTVDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving is unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when removing is successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(testTVDetail);
      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test(
      'should return DatabaseFailure when removing is unsuccessful',
      () async {
        // arrange
        when(mockLocalDataSource.removeWatchlist(testTVTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlist(testTVDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
      },
    );
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });

    test('should return true when data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVById(tId))
          .thenAnswer((_) async => testTVTable);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, true);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TV', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTVs())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTVs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}
