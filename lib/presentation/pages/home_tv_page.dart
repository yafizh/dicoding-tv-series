import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv_series/presentation/pages/popular_tvs_page.dart';
import 'package:tv_series/presentation/pages/search_tv_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv_series/presentation/pages/tv_detail_page.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  static const routeName = '/home-tv';

  const HomeTVPage({super.key});

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnTheAirTVsBloc>().add(const FetchTVList());
    context.read<PopularTVsBloc>().add(const FetchTVList());
    context.read<TopRatedTVsBloc>().add(const FetchTVList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(currentRoute: HomeTVPage.routeName),
      appBar: AppBar(
        title: Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVPage.routeName);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'On The Air',
                onTap: () {
                  return Navigator.pushNamed(
                    context,
                    OnTheAirTVsPage.routeName,
                  );
                },
              ),
              BlocBuilder<OnTheAirTVsBloc, TVListState>(
                builder: (_, state) => _buildTVList(state),
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  return Navigator.pushNamed(context, PopularTVsPage.routeName);
                },
              ),
              BlocBuilder<PopularTVsBloc, TVListState>(
                builder: (_, state) => _buildTVList(state),
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  return Navigator.pushNamed(
                    context,
                    TopRatedTVsPage.routeName,
                  );
                },
              ),
              BlocBuilder<TopRatedTVsBloc, TVListState>(
                builder: (_, state) => _buildTVList(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTVList(TVListState state) {
    return switch (state) {
      TVListLoading() => Center(child: CircularProgressIndicator()),
      TVListHasData(:final tvs) => TVList(tvs),
      _ => Text('Failed'),
    };
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVList extends StatelessWidget {
  final List<TV> tvs;

  const TVList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (_, _) {
                    return Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
