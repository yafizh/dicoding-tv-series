import 'package:dartz/dartz.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getOnTheAirTVs();
  Future<Either<Failure, List<TV>>> getPopularTVs();
  Future<Either<Failure, List<TV>>> getTopRatedTVs();
  Future<Either<Failure, TVDetail>> getTVDetail(int id);
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id);
  Future<Either<Failure, SeasonDetail>> getTVSeasonDetail(
    int id,
    int seasonNumber,
  );
  Future<Either<Failure, List<TV>>> searchTVs(String query);
  Future<Either<Failure, String>> saveWatchlist(TVDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TVDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TV>>> getWatchlistTVs();
}
