import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class GetWatchlistTVs {
  final TVRepository _repository;

  GetWatchlistTVs(this._repository);

  Future<Either<Failure, List<TV>>> execute() {
    return _repository.getWatchlistTVs();
  }
}
