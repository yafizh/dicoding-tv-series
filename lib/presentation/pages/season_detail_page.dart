import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_series/common/constants.dart';
import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/episode.dart';
import 'package:tv_series/presentation/provider/season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonDetailPageArgs {
  final int tvId;
  final int seasonNumber;

  const SeasonDetailPageArgs({required this.tvId, required this.seasonNumber});
}

class SeasonDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv-season';

  final int tvId;
  final int seasonNumber;

  const SeasonDetailPage({
    super.key,
    required this.tvId,
    required this.seasonNumber,
  });

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<SeasonDetailNotifier>(
        context,
        listen: false,
      ).fetchSeasonDetail(widget.tvId, widget.seasonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Season ${widget.seasonNumber}')),
      body: Consumer<SeasonDetailNotifier>(
        builder: (_, data, _) {
          if (data.state == RequestState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (data.state == RequestState.loaded) {
            final season = data.seasonDetail;
            return ListView(
              key: Key('episode_list'),
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(season.name, style: heading5),
                if (season.airDate != null) Text('Aired ${season.airDate}'),
                SizedBox(height: 8),
                if (season.overview.isNotEmpty) Text(season.overview),
                SizedBox(height: 16),
                Text('Episodes', style: heading6),
                SizedBox(height: 8),
                ...season.episodes.map((episode) => _EpisodeTile(episode)),
              ],
            );
          } else {
            return Center(key: Key('error_message'), child: Text(data.message));
          }
        },
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final Episode episode;

  const _EpisodeTile(this.episode);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: episode.stillPath != null
                  ? CachedNetworkImage(
                      imageUrl: '$baseImageUrl${episode.stillPath}',
                      width: 100,
                      placeholder: (context, url) {
                        return Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : Container(
                      width: 100,
                      height: 56,
                      color: grey,
                      child: Icon(Icons.tv),
                    ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E${episode.episodeNumber} • ${episode.name}',
                    style: subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    episode.overview.isNotEmpty
                        ? episode.overview
                        : 'No overview available',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: bodyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
