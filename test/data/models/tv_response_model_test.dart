import 'dart:convert';

import 'package:tv_series/data/models/tv_model.dart';
import 'package:tv_series/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVModel = TVModel(
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2011-04-17',
    genreIds: [10765, 18],
    id: 1399,
    name: 'Game of Thrones',
    originalName: 'Game of Thrones',
    overview: 'Seven noble families fight for control of the mythical land of Westeros.',
    popularity: 369.594,
    posterPath: '/poster.jpg',
    voteAverage: 8.3,
    voteCount: 11504,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/search_tv_game_of_thrones.json'),
      );
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result, TVResponse(tvList: [tTVModel]));
    });

    test('should drop results without a poster path', () async {
      // arrange
      final jsonMap = json.decode(
        readJson('dummy_data/search_tv_game_of_thrones.json'),
      ) as Map<String, dynamic>;
      (jsonMap['results'] as List).first['poster_path'] = null;
      // act
      final result = TVResponse.fromJson(jsonMap);
      // assert
      expect(result.tvList, isEmpty);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final tTVResponseModel = TVResponse(tvList: [tTVModel]);
      // act
      final result = tTVResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": '/backdrop.jpg',
            "first_air_date": '2011-04-17',
            "genre_ids": [10765, 18],
            "id": 1399,
            "name": 'Game of Thrones',
            "original_name": 'Game of Thrones',
            "overview": 'Seven noble families fight for control of the mythical land of Westeros.',
            "popularity": 369.594,
            "poster_path": '/poster.jpg',
            "vote_average": 8.3,
            "vote_count": 11504,
          },
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
