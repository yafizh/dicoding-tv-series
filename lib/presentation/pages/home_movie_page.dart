import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/popular_movies_page.dart';
import 'package:tv_series/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/provider/movie_list_notifier.dart';
import 'package:tv_series/presentation/widgets/app_drawer.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = '/home';

  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentRoute: HomeMoviePage.routeName),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: heading6),
              Consumer<MovieListNotifier>(
                builder: (_, data, _) {
                  final state = data.nowPlayingState;
                  if (state == RequestState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.loaded) {
                    return MovieList(data.nowPlayingMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  return Navigator.pushNamed(
                    context,
                    PopularMoviesPage.routeName,
                  );
                },
              ),
              Consumer<MovieListNotifier>(
                builder: (_, data, _) {
                  final state = data.popularMoviesState;
                  if (state == RequestState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.loaded) {
                    return MovieList(data.popularMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  return Navigator.pushNamed(
                    context,
                    TopRatedMoviesPage.routeName,
                  );
                },
              ),
              Consumer<MovieListNotifier>(
                builder: (_, data, _) {
                  final state = data.topRatedMoviesState;
                  if (state == RequestState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state == RequestState.loaded) {
                    return MovieList(data.topRatedMovies);
                  } else {
                    return Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) {
                    return Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
