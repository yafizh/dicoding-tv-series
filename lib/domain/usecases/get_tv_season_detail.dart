import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class GetTVSeasonDetail {
  final TVRepository repository;

  GetTVSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int seasonNumber) {
    return repository.getTVSeasonDetail(id, seasonNumber);
  }
}
