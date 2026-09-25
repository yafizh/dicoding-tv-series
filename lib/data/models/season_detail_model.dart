import 'package:tv_series/data/models/episode_model.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  const SeasonDetailResponse({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? airDate;
  final List<EpisodeModel> episodes;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) {
    return SeasonDetailResponse(
      airDate: json["air_date"],
      episodes: List<EpisodeModel>.from(
        json["episodes"].map((x) => EpisodeModel.fromJson(x)),
      ),
      id: json["id"],
      name: json["name"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      seasonNumber: json["season_number"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "air_date": airDate,
      "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
      "id": id,
      "name": name,
      "overview": overview,
      "poster_path": posterPath,
      "season_number": seasonNumber,
    };
  }

  SeasonDetail toEntity() {
    return SeasonDetail(
      airDate: airDate,
      episodes: episodes.map((episode) => episode.toEntity()).toList(),
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props {
    return [airDate, episodes, id, name, overview, posterPath, seasonNumber];
  }
}
