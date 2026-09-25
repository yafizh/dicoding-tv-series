import 'package:tv_series/common/utils.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVsPage extends StatefulWidget {
  static const routeName = '/watchlist-tv';

  const WatchlistTVsPage({super.key});

  @override
  State<WatchlistTVsPage> createState() => _WatchlistTVsPageState();
}

class _WatchlistTVsPageState extends State<WatchlistTVsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistTVsBloc>().add(const FetchTVList());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVsBloc>().add(const FetchTVList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVsBloc, TVListState>(
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
