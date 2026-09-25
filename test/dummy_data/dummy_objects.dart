import 'package:tv_series/data/models/movie_table.dart';
import 'package:tv_series/data/models/tv_table.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/domain/entities/genre.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/domain/entities/movie_detail.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/season_detail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTV = TV(
  backdropPath: '/backdrop.jpg',
  firstAirDate: '2011-04-17',
  genreIds: [10765, 18],
  id: 1399,
  name: 'Game of Thrones',
  originalName: 'Game of Thrones',
  overview: 'Seven noble families fight for control of the mythical land of Westeros.',
  popularity: 369.594,
  posterPath: '/poster.jpg',
  voteAverage: 8.3,
  voteCount: 11504,
);

final testTVList = [testTV];

final testTVDetail = TVDetail(
  backdropPath: 'backdropPath',
  episodeRunTime: [60],
  firstAirDate: 'firstAirDate',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: 'airDate',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVTable = TVTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVMap = {
  'id': 1,
  'name': 'name',
  'overview': 'overview',
  'posterPath': 'posterPath',
};

final testEpisode = Episode(
  airDate: 'airDate',
  episodeNumber: 1,
  id: 1,
  name: 'Winter Is Coming',
  overview: 'overview',
  runtime: 62,
  seasonNumber: 1,
  stillPath: 'stillPath',
  voteAverage: 7.6,
);

final testSeasonDetail = SeasonDetail(
  airDate: 'airDate',
  episodes: [testEpisode],
  id: 1,
  name: 'Season 1',
  overview: 'overview',
  posterPath: 'posterPath',
  seasonNumber: 1,
);
