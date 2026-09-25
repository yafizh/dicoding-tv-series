import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/repositories/movie_repository.dart';
import 'package:tv_series/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
