import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<TopRatedTVsNotifier>(
        context,
        listen: false,
      ).fetchTopRatedTVs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVsNotifier>(
          builder: (_, data, _) {
            if (data.state == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = data.tvs[index];
                  return TVCard(tv);
                },
                itemCount: data.tvs.length,
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
}
