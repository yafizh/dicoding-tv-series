import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter/foundation.dart';

class SeasonDetailNotifier extends ChangeNotifier {
  final GetTVSeasonDetail getTVSeasonDetail;

  SeasonDetailNotifier({required this.getTVSeasonDetail});

  late SeasonDetail _seasonDetail;
  SeasonDetail get seasonDetail => _seasonDetail;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchSeasonDetail(int id, int seasonNumber) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getTVSeasonDetail.execute(id, seasonNumber);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (data) {
        _seasonDetail = data;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
