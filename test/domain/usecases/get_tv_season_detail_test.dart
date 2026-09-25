import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeasonDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonDetail(mockTVRepository);
  });

  final tId = 1;
  final tSeasonNumber = 1;

  test('should get season detail from the repository', () async {
    // arrange
    when(mockTVRepository.getTVSeasonDetail(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, Right(testSeasonDetail));
  });
}
