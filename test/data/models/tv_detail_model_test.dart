import 'dart:convert';

import 'package:tv_series/data/models/tv_detail_model.dart';
import 'package:tv_series/domain/entities/genre.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tJsonMap = json.decode(
    readJson('dummy_data/tv_detail.json'),
  ) as Map<String, dynamic>;

  test('should return a valid model from JSON', () async {
    // act
    final result = TVDetailResponse.fromJson(tJsonMap);
    // assert
    expect(result.id, 1399);
    expect(result.name, 'Game of Thrones');
    expect(result.numberOfSeasons, 8);
    expect(result.numberOfEpisodes, 73);
    expect(result.episodeRunTime, [60]);
    expect(result.seasons.length, 2);
  });

  test('should convert to TVDetail entity', () async {
    // act
    final result = TVDetailResponse.fromJson(tJsonMap).toEntity();
    // assert
    expect(result.id, 1399);
    expect(result.name, 'Game of Thrones');
    expect(result.genres, [Genre(id: 10765, name: 'Sci-Fi & Fantasy')]);
    expect(
      result.seasons.last,
      Season(
        airDate: '2011-04-17',
        episodeCount: 10,
        id: 3624,
        name: 'Season 1',
        overview: 'Trouble is brewing in the Seven Kingdoms of Westeros.',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
      ),
    );
  });

  test('should default numberOfEpisodes to 0 when it is missing', () async {
    // arrange
    final jsonMap = Map<String, dynamic>.from(tJsonMap);
    jsonMap['number_of_episodes'] = null;
    // act
    final result = TVDetailResponse.fromJson(jsonMap);
    // assert
    expect(result.numberOfEpisodes, 0);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = TVDetailResponse.fromJson(tJsonMap).toJson();
    // assert
    expect(result['id'], 1399);
    expect(result['name'], 'Game of Thrones');
    expect(result['number_of_seasons'], 8);
    expect((result['seasons'] as List).length, 2);
  });
}
