import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/domain/entities/movie.dart';
import 'package:tv_series/presentation/pages/movie_detail_page.dart';
import 'package:tv_series/presentation/pages/popular_movies_page.dart';
import 'package:tv_series/presentation/pages/search_page.dart';
import 'package:tv_series/presentation/pages/top_rated_movies_page.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<NowPlayingMoviesBloc>().add(const FetchMovieList());
    context.read<PopularMoviesBloc>().add(const FetchMovieList());
    context.read<TopRatedMoviesBloc>().add(const FetchMovieList());
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
              BlocBuilder<NowPlayingMoviesBloc, MovieListState>(
                builder: (_, state) => _buildMovieList(state),
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
              BlocBuilder<PopularMoviesBloc, MovieListState>(
                builder: (_, state) => _buildMovieList(state),
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
              BlocBuilder<TopRatedMoviesBloc, MovieListState>(
                builder: (_, state) => _buildMovieList(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieList(MovieListState state) {
    return switch (state) {
      MovieListLoading() => Center(child: CircularProgressIndicator()),
      MovieListHasData(:final movies) => MovieList(movies),
      _ => Text('Failed'),
    };
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
