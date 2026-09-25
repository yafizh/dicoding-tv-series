import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVsPage extends StatefulWidget {
  static const routeName = '/on-the-air-tv';

  const OnTheAirTVsPage({super.key});

  @override
  State<OnTheAirTVsPage> createState() => _OnTheAirTVsPageState();
}

class _OnTheAirTVsPageState extends State<OnTheAirTVsPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnTheAirTVsBloc>().add(const FetchTVList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTVsBloc, TVListState>(
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
