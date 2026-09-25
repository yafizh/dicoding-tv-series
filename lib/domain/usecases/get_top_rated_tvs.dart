import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class GetTopRatedTVs {
  final TVRepository repository;

  GetTopRatedTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getTopRatedTVs();
  }
}
