import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/repositories/movie_repository.dart';
import 'package:tv_series/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
