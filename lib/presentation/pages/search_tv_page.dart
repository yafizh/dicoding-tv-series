import 'package:tv_series/common/constants.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                context.read<TVSearchBloc>().add(FetchTVSearch(query));
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
            BlocBuilder<TVSearchBloc, TVListState>(
              builder: (_, state) {
                return switch (state) {
                  TVListLoading() => Center(child: CircularProgressIndicator()),
                  TVListHasData(:final tvs) => Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) => TVCard(tvs[index]),
                      itemCount: tvs.length,
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
