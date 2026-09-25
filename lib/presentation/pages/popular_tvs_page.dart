import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVsPage extends StatefulWidget {
  static const routeName = '/popular-tv';

  const PopularTVsPage({super.key});

  @override
  State<PopularTVsPage> createState() => _PopularTVsPageState();
}

class _PopularTVsPageState extends State<PopularTVsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTVsBloc>().add(const FetchTVList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVsBloc, TVListState>(
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
