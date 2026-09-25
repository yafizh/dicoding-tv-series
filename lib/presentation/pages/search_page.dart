import 'package:tv_series/common/constants.dart';
import 'package:tv_series/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:tv_series/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:tv_series/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchBloc>().add(FetchMovieSearch(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text('Search Result', style: heading6),
            BlocBuilder<MovieSearchBloc, MovieListState>(
              builder: (_, state) {
                return switch (state) {
                  MovieListLoading() => Center(
                    child: CircularProgressIndicator(),
                  ),
                  MovieListHasData(:final movies) => Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) => MovieCard(movies[index]),
                      itemCount: movies.length,
                    ),
                  ),
                  _ => const Expanded(child: SizedBox()),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
