import 'package:tv_series/data/models/tv_model.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  final tTVJson = {
    "backdrop_path": 'backdropPath',
    "first_air_date": 'firstAirDate',
    "genre_ids": [1, 2, 3],
    "id": 1,
    "name": 'name',
    "original_name": 'originalName',
    "overview": 'overview',
    "popularity": 1.0,
    "poster_path": 'posterPath',
    "vote_average": 1.0,
    "vote_count": 1,
  };

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });

  test('should return a valid model from JSON', () async {
    final result = TVModel.fromJson(tTVJson);
    expect(result, tTVModel);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tTVModel.toJson();
    expect(result, tTVJson);
  });
}
