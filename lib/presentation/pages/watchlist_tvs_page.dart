import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/common/utils.dart';
import 'package:tv_series/presentation/provider/watchlist_tv_notifier.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<WatchlistTVNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTVs();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistTVNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTVs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTVNotifier>(
          builder: (_, data, _) {
            if (data.watchlistState == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.watchlistState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = data.watchlistTVs[index];
                  return TVCard(tv);
                },
                itemCount: data.watchlistTVs.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
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
