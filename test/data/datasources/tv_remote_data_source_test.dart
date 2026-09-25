import 'dart:convert';

import 'package:tv_series/common/exception.dart';
import 'package:tv_series/data/datasources/tv_remote_data_source.dart';
import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:tv_series/data/models/tv_detail_model.dart';
import 'package:tv_series/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TVs', () {
    final tTVList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer((_) async {
          return http.Response(readJson('dummy_data/tv_on_the_air.json'), 200);
        });
        // act
        final result = await dataSource.getOnTheAirTVs();
        // assert
        expect(result, equals(tTVList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getOnTheAirTVs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TVs', () {
    final tTVList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvList;

    test('should return list of tvs when response is success (200)', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async {
            return http.Response(readJson('dummy_data/tv_popular.json'), 200);
          });
      // act
      final result = await dataSource.getPopularTVs();
      // assert
      expect(result, tTVList);
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTVs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TVs', () {
    final tTVList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_top_rated.json')),
    ).tvList;

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async {
            return http.Response(readJson('dummy_data/tv_top_rated.json'), 200);
          });
      // act
      final result = await dataSource.getTopRatedTVs();
      // assert
      expect(result, tTVList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTVs();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv detail', () {
    final tId = 1399;

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async {
            return http.Response(readJson('dummy_data/tv_detail.json'), 200);
          });
      // act
      final result = await dataSource.getTVDetail(tId);
      // assert
      expect(
        result,
        equals(
          TVDetailResponse.fromJson(
            json.decode(readJson('dummy_data/tv_detail.json')),
          ),
        ),
      );
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTVDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv recommendations', () {
    final tTVList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;
    final tId = 1399;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async {
          return http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          );
        });
        // act
        final result = await dataSource.getTVRecommendations(tId);
        // assert
        expect(result, equals(tTVList));
      },
    );

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTVRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get tv season detail', () {
    final tId = 1399;
    final tSeasonNumber = 1;

    test('should return season detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey'),
        ),
      ).thenAnswer((_) async {
        return http.Response(readJson('dummy_data/tv_season_detail.json'), 200);
      });
      // act
      final result = await dataSource.getTVSeasonDetail(tId, tSeasonNumber);
      // assert
      expect(
        result,
        equals(
          SeasonDetailResponse.fromJson(
            json.decode(readJson('dummy_data/tv_season_detail.json')),
          ),
        ),
      );
    });

    test(
      'should throw Server Exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/season/$tSeasonNumber?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tvs', () {
    final tSearchResult = TVResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv_game_of_thrones.json')),
    ).tvList;
    final tQuery = 'Game of Thrones';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
        ),
      ).thenAnswer((_) async {
        return http.Response(
          readJson('dummy_data/search_tv_game_of_thrones.json'),
          200,
        );
      });
      // act
      final result = await dataSource.searchTVs(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTVs(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
