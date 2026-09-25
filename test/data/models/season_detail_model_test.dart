import 'dart:convert';

import 'package:tv_series/data/models/season_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tJsonMap = json.decode(
    readJson('dummy_data/tv_season_detail.json'),
  ) as Map<String, dynamic>;

  test('should return a valid model from JSON', () async {
    // act
    final result = SeasonDetailResponse.fromJson(tJsonMap);
    // assert
    expect(result.id, 3624);
    expect(result.name, 'Season 1');
    expect(result.seasonNumber, 1);
    expect(result.episodes.length, 2);
    expect(result.episodes.first.name, 'Winter Is Coming');
  });

  test('should convert to SeasonDetail entity', () async {
    // act
    final result = SeasonDetailResponse.fromJson(tJsonMap).toEntity();
    // assert
    expect(result.id, 3624);
    expect(result.episodes.length, 2);
    expect(result.episodes.first.episodeNumber, 1);
    expect(result.episodes.first.runtime, 62);
    expect(result.episodes.first.stillPath, '/still1.jpg');
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = SeasonDetailResponse.fromJson(tJsonMap).toJson();
    // assert
    expect(result['id'], 3624);
    expect(result['season_number'], 1);
    expect((result['episodes'] as List).length, 2);
  });
}
