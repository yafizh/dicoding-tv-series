import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tv_series/common/exception.dart';
import 'package:tv_series/common/failure.dart';
import 'package:tv_series/data/datasources/tv_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_remote_data_source.dart';
import 'package:tv_series/data/models/tv_table.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;
  final TVLocalDataSource localDataSource;

  TVRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TV>>> getOnTheAirTVs() async {
    try {
      final result = await remoteDataSource.getOnTheAirTVs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getPopularTVs() async {
    try {
      final result = await remoteDataSource.getPopularTVs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTopRatedTVs() async {
    try {
      final result = await remoteDataSource.getTopRatedTVs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, TVDetail>> getTVDetail(int id) async {
    try {
      final result = await remoteDataSource.getTVDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTVRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, SeasonDetail>> getTVSeasonDetail(
    int id,
    int seasonNumber,
  ) async {
    try {
      final result = await remoteDataSource.getTVSeasonDetail(id, seasonNumber);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> searchTVs(String query) async {
    try {
      final result = await remoteDataSource.searchTVs(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException {
      return Left(SSLFailure('Certificate verification failed'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TVDetail tv) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TVTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TVDetail tv) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TVTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    try {
      final result = await localDataSource.getTVById(id);
      return result != null;
    } on DatabaseException {
      return false;
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getWatchlistTVs() async {
    try {
      final result = await localDataSource.getWatchlistTVs();
      return Right(result.map((data) => data.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
