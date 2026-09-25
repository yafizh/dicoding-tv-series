import 'package:tv_series/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should build a table from a TVDetail entity', () async {
    final result = TVTable.fromEntity(testTVDetail);
    expect(result, testTVTable);
  });

  test('should build a table from a database map', () async {
    final result = TVTable.fromMap(testTVMap);
    expect(result, testTVTable);
  });

  test('should return a JSON map containing proper data', () async {
    final result = testTVTable.toJson();
    expect(result, testTVMap);
  });

  test('should convert to a watchlist TV entity', () async {
    final result = testTVTable.toEntity();
    expect(result, testWatchlistTV);
  });
}
