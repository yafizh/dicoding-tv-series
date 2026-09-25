import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/provider/movie_search_notifier.dart';
import 'package:tv_series/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                Provider.of<MovieSearchNotifier>(
                  context,
                  listen: false,
                ).fetchMovieSearch(query);
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
            Consumer<MovieSearchNotifier>(
              builder: (_, data, _) {
                if (data.state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) {
                        final movie = data.searchResult[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return const Expanded(child: SizedBox());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
