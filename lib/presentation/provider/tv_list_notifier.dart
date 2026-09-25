import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv_series/domain/usecases/get_popular_tvs.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/material.dart';

class TVListNotifier extends ChangeNotifier {
  var _onTheAirTVs = <TV>[];
  List<TV> get onTheAirTVs => _onTheAirTVs;

  RequestState _onTheAirState = RequestState.empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTVs = <TV>[];
  List<TV> get popularTVs => _popularTVs;

  RequestState _popularTVsState = RequestState.empty;
  RequestState get popularTVsState => _popularTVsState;

  var _topRatedTVs = <TV>[];
  List<TV> get topRatedTVs => _topRatedTVs;

  RequestState _topRatedTVsState = RequestState.empty;
  RequestState get topRatedTVsState => _topRatedTVsState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getOnTheAirTVs,
    required this.getPopularTVs,
    required this.getTopRatedTVs,
  });

  final GetOnTheAirTVs getOnTheAirTVs;
  final GetPopularTVs getPopularTVs;
  final GetTopRatedTVs getTopRatedTVs;

  Future<void> fetchOnTheAirTVs() async {
    _onTheAirState = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTVs.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _onTheAirState = RequestState.loaded;
        _onTheAirTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVs() async {
    _popularTVsState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVs.execute();
    result.fold(
      (failure) {
        _popularTVsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _popularTVsState = RequestState.loaded;
        _popularTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVs() async {
    _topRatedTVsState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVs.execute();
    result.fold(
      (failure) {
        _topRatedTVsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTVsState = RequestState.loaded;
        _topRatedTVs = tvsData;
        notifyListeners();
      },
    );
  }
}
