import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/provider/tv_search_notifier.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTVPage extends StatelessWidget {
  static const routeName = '/search-tv';

  const SearchTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: Key('query_input'),
              onSubmitted: (query) {
                Provider.of<TVSearchNotifier>(
                  context,
                  listen: false,
                ).fetchTVSearch(query);
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
            Consumer<TVSearchNotifier>(
              builder: (_, data, _) {
                if (data.state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) {
                        final tv = result[index];
                        return TVCard(tv);
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
