import 'package:tv_series/common/exception.dart';
import 'package:tv_series/data/datasources/db/database_helper.dart';
import 'package:tv_series/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlist(TVTable tv);
  Future<String> removeWatchlist(TVTable tv);
  Future<TVTable?> getTVById(int id);
  Future<List<TVTable>> getWatchlistTVs();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TVTable tv) async {
    try {
      await databaseHelper.insertTVWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeTVWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    try {
      final result = await databaseHelper.getTVById(id);
      if (result != null) {
        return TVTable.fromMap(result);
      } else {
        return null;
      }
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTVs() async {
    try {
      final result = await databaseHelper.getWatchlistTVs();
      return result.map((data) => TVTable.fromMap(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
