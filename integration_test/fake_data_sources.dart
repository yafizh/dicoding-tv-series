import 'dart:convert';

import 'package:tv_series/data/datasources/movie_local_data_source.dart';
import 'package:tv_series/data/datasources/tv_local_data_source.dart';
import 'package:tv_series/data/models/movie_table.dart';
import 'package:tv_series/data/models/tv_table.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// In-memory stand-ins for the sqflite-backed watchlist, so the integration
/// test can exercise the real repositories without a device database.
class InMemoryMovieLocalDataSource implements MovieLocalDataSource {
  final _movies = <int, MovieTable>{};

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    _movies[movie.id] = movie;
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    _movies.remove(movie.id);
    return 'Removed from Watchlist';
  }

  @override
  Future<MovieTable?> getMovieById(int id) async => _movies[id];

  @override
  Future<List<MovieTable>> getWatchlistMovies() async =>
      _movies.values.toList();
}

class InMemoryTVLocalDataSource implements TVLocalDataSource {
  final _tvs = <int, TVTable>{};

  @override
  Future<String> insertWatchlist(TVTable tv) async {
    _tvs[tv.id] = tv;
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    _tvs.remove(tv.id);
    return 'Removed from Watchlist';
  }

  @override
  Future<TVTable?> getTVById(int id) async => _tvs[id];

  @override
  Future<List<TVTable>> getWatchlistTVs() async => _tvs.values.toList();
}

Map<String, dynamic> _tv(int id, String name) => {
  'backdrop_path': '/backdrop.jpg',
  'first_air_date': '2011-04-17',
  'genre_ids': [10765],
  'id': id,
  'name': name,
  'original_name': name,
  'overview': 'Seven noble families fight for control of Westeros.',
  'popularity': 369.594,
  'poster_path': '/poster.jpg',
  'vote_average': 8.3,
  'vote_count': 11504,
};

Map<String, dynamic> _movie(int id, String title) => {
  'adult': false,
  'backdrop_path': '/backdrop.jpg',
  'genre_ids': [28],
  'id': id,
  'original_title': title,
  'overview': 'A movie overview.',
  'popularity': 60.441,
  'poster_path': '/poster.jpg',
  'release_date': '2002-05-01',
  'title': title,
  'video': false,
  'vote_average': 7.2,
  'vote_count': 13507,
};

Map<String, dynamic> _page(List<Map<String, dynamic>> results) => {
  'page': 1,
  'results': results,
  'total_pages': 1,
  'total_results': results.length,
};

final _tvDetail = {
  'backdrop_path': '/backdrop.jpg',
  'episode_run_time': [60],
  'first_air_date': '2011-04-17',
  'genres': [
    {'id': 10765, 'name': 'Sci-Fi & Fantasy'},
  ],
  'homepage': 'https://example.com',
  'id': 1399,
  'name': 'Game of Thrones',
  'number_of_episodes': 73,
  'number_of_seasons': 8,
  'original_name': 'Game of Thrones',
  'overview': 'Seven noble families fight for control of Westeros.',
  'popularity': 369.594,
  'poster_path': '/poster.jpg',
  'seasons': [
    {
      'air_date': '2011-04-17',
      'episode_count': 10,
      'id': 3624,
      'name': 'Season 1',
      'overview': 'Trouble is brewing in the Seven Kingdoms.',
      'poster_path': '/season1.jpg',
      'season_number': 1,
    },
  ],
  'status': 'Ended',
  'tagline': 'Winter Is Coming',
  'vote_average': 8.3,
  'vote_count': 11504,
};

final _seasonDetail = {
  'air_date': '2011-04-17',
  'episodes': [
    {
      'air_date': '2011-04-17',
      'episode_number': 1,
      'id': 63056,
      'name': 'Winter Is Coming',
      'overview': 'Jon Arryn, the Hand of the King, is dead.',
      'runtime': 62,
      'season_number': 1,
      'still_path': '/still1.jpg',
      'vote_average': 7.6,
    },
  ],
  'id': 3624,
  'name': 'Season 1',
  'overview': 'Trouble is brewing in the Seven Kingdoms.',
  'poster_path': '/season1.jpg',
  'season_number': 1,
};

final _movieDetail = {
  'adult': false,
  'backdrop_path': '/backdrop.jpg',
  'budget': 139000000,
  'genres': [
    {'id': 28, 'name': 'Action'},
  ],
  'homepage': 'https://example.com',
  'id': 557,
  'imdb_id': 'tt0145487',
  'original_language': 'en',
  'original_title': 'Spider-Man',
  'overview': 'A movie overview.',
  'popularity': 60.441,
  'poster_path': '/poster.jpg',
  'release_date': '2002-05-01',
  'revenue': 821708551,
  'runtime': 121,
  'status': 'Released',
  'tagline': 'With great power comes great responsibility.',
  'title': 'Spider-Man',
  'video': false,
  'vote_average': 7.2,
  'vote_count': 13507,
};

/// Serves canned TMDB responses so the app under test never touches the network.
http.Client createFakeTmdbClient() {
  return MockClient((request) async {
    final path = request.url.path;
    Object body;

    if (path.contains('/tv/on_the_air')) {
      body = _page([_tv(1399, 'Game of Thrones')]);
    } else if (path.contains('/tv/popular')) {
      body = _page([_tv(66732, 'Stranger Things')]);
    } else if (path.contains('/tv/top_rated')) {
      body = _page([_tv(1396, 'Breaking Bad')]);
    } else if (path.contains('/season/')) {
      body = _seasonDetail;
    } else if (path.contains('/recommendations')) {
      body = path.startsWith('/3/tv')
          ? _page([_tv(1396, 'Breaking Bad')])
          : _page([_movie(558, 'Spider-Man 2')]);
    } else if (path.startsWith('/3/tv/')) {
      body = _tvDetail;
    } else if (path.contains('/search/tv')) {
      body = _page([_tv(1399, 'Game of Thrones')]);
    } else if (path.contains('/search/movie')) {
      body = _page([_movie(557, 'Spider-Man')]);
    } else if (path.contains('/movie/now_playing') ||
        path.contains('/movie/popular') ||
        path.contains('/movie/top_rated')) {
      body = _page([_movie(557, 'Spider-Man')]);
    } else if (path.startsWith('/3/movie/')) {
      body = _movieDetail;
    } else {
      return http.Response('Not Found', 404);
    }

    return http.Response(json.encode(body), 200);
  });
}
