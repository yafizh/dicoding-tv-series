import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
