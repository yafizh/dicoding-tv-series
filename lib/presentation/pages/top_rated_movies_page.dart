import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedMoviesBloc>().add(const FetchMovieList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, MovieListState>(
          builder: (_, state) {
            return switch (state) {
              MovieListLoading() => Center(child: CircularProgressIndicator()),
              MovieListHasData(:final movies) => ListView.builder(
                itemBuilder: (_, index) => MovieCard(movies[index]),
                itemCount: movies.length,
              ),
              MovieListError(:final message) => Center(
                key: Key('error_message'),
                child: Text(message),
              ),
              MovieListEmpty() => const SizedBox(),
            };
          },
        ),
      ),
    );
  }
}
