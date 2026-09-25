import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';

class MockNowPlayingMoviesBloc extends MockBloc<MovieListEvent, MovieListState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc extends MockBloc<MovieListEvent, MovieListState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc extends MockBloc<MovieListEvent, MovieListState>
    implements TopRatedMoviesBloc {}

class MockWatchlistMoviesBloc extends MockBloc<MovieListEvent, MovieListState>
    implements WatchlistMoviesBloc {}

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieListState>
    implements MovieSearchBloc {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockOnTheAirTVsBloc extends MockBloc<TVListEvent, TVListState>
    implements OnTheAirTVsBloc {}

class MockPopularTVsBloc extends MockBloc<TVListEvent, TVListState>
    implements PopularTVsBloc {}

class MockTopRatedTVsBloc extends MockBloc<TVListEvent, TVListState>
    implements TopRatedTVsBloc {}

class MockWatchlistTVsBloc extends MockBloc<TVListEvent, TVListState>
    implements WatchlistTVsBloc {}

class MockTVSearchBloc extends MockBloc<TVSearchEvent, TVListState>
    implements TVSearchBloc {}

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class MockSeasonDetailBloc
    extends MockBloc<SeasonDetailEvent, SeasonDetailState>
    implements SeasonDetailBloc {}
