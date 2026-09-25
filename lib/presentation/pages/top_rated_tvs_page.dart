import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTVsPage({super.key});

  @override
  State<TopRatedTVsPage> createState() => _TopRatedTVsPageState();
}

class _TopRatedTVsPageState extends State<TopRatedTVsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TopRatedTVsBloc>().add(const FetchTVList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVsBloc, TVListState>(
          builder: (_, state) {
            return switch (state) {
              TVListLoading() => Center(child: CircularProgressIndicator()),
              TVListHasData(:final tvs) => ListView.builder(
                itemBuilder: (_, index) => TVCard(tvs[index]),
                itemCount: tvs.length,
              ),
              TVListError(:final message) => Center(
                key: Key('error_message'),
                child: Text(message),
              ),
              TVListEmpty() => const SizedBox(),
            };
          },
        ),
      ),
    );
  }
}
