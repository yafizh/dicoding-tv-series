import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularMoviesBloc>().add(const FetchMovieList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, MovieListState>(
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
