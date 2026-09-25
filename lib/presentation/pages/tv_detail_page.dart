import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/genre.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/entities/tv_detail.dart';
import 'package:tv_series/presentation/pages/season_detail_page.dart';
import 'package:tv_series/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;
  const TVDetailPage({super.key, required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TVDetailBloc>()
      ..add(FetchTVDetail(widget.id))
      ..add(LoadTVWatchlistStatus(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TVDetailBloc, TVDetailState>(
        listenWhen: (previous, current) {
          return previous.watchlistMessage != current.watchlistMessage &&
              current.watchlistMessage.isNotEmpty;
        },
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == TVDetailBloc.watchlistAddSuccessMessage ||
              message == TVDetailBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        },
        builder: (_, state) {
          if (state.tvState == RequestState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.tvState == RequestState.loaded) {
            return SafeArea(
              child: TVDetailContent(
                state.tv!,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(state.message);
          }
        },
      ),
    );
  }
}

class TVDetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const TVDetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) {
            return Center(child: CircularProgressIndicator());
          },
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tv.name, style: heading5),
                            FilledButton(
                              key: Key('watchlist_button'),
                              onPressed: () {
                                final bloc = context.read<TVDetailBloc>();
                                if (!isAddedWatchlist) {
                                  bloc.add(AddTVToWatchlist(tv));
                                } else {
                                  bloc.add(RemoveTVFromWatchlist(tv));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            Text(_showDuration(tv.episodeRunTime)),
                            Text(
                              '${tv.numberOfSeasons} Season(s) • '
                              '${tv.numberOfEpisodes} Episode(s)',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.star,
                                      color: mikadoYellow,
                                    );
                                  },
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(tv.overview),
                            SizedBox(height: 16),
                            Text('Seasons', style: heading6),
                            _SeasonList(tvId: tv.id, seasons: tv.seasons),
                            SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            BlocBuilder<TVDetailBloc, TVDetailState>(
                              builder: (_, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.error) {
                                  return Text(state.message);
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: Key('recommendation_list'),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TVDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseImageUrl${tv.posterPath}',
                                                placeholder: (context, url) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorWidget: (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(List<int> episodeRunTime) {
    if (episodeRunTime.isEmpty) {
      return '-';
    }

    final runtime = episodeRunTime.first;
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _SeasonList extends StatelessWidget {
  final int tvId;
  final List<Season> seasons;

  const _SeasonList({required this.tvId, required this.seasons});

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return Text('No season information available');
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        key: Key('season_list'),
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                SeasonDetailPage.routeName,
                arguments: SeasonDetailPageArgs(
                  tvId: tvId,
                  seasonNumber: season.seasonNumber,
                ),
              );
            },
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: season.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl: '$baseImageUrl${season.posterPath}',
                              width: 92,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Icon(Icons.error);
                              },
                            )
                          : Container(
                              width: 92,
                              color: grey,
                              child: Icon(Icons.tv),
                            ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    season.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('${season.episodeCount} episodes', style: bodyText),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
