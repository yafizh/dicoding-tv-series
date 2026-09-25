import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TVTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  const TVTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TVTable.fromEntity(TVDetail tv) {
    return TVTable(
      id: tv.id,
      name: tv.name,
      posterPath: tv.posterPath,
      overview: tv.overview,
    );
  }

  factory TVTable.fromMap(Map<String, dynamic> map) {
    return TVTable(
      id: map['id'],
      name: map['name'],
      posterPath: map['posterPath'],
      overview: map['overview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'posterPath': posterPath,
      'overview': overview,
    };
  }

  TV toEntity() {
    return TV.watchlist(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
    );
  }

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
