import 'package:tv_series/presentation/pages/about_page.dart';
import 'package:tv_series/presentation/pages/home_movie_page.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:tv_series/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_series/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';

/// The navigation drawer shared by the movie and TV series home pages.
///
/// [currentRoute] is the route name of the page hosting the drawer, so that
/// tapping its own entry simply closes the drawer instead of re-pushing it.
class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: Text('Ditonton'),
            accountEmail: Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            key: Key('drawer_movies'),
            leading: Icon(Icons.movie),
            title: Text('Movies'),
            onTap: () => _navigate(context, HomeMoviePage.routeName),
          ),
          ListTile(
            key: Key('drawer_tv_series'),
            leading: Icon(Icons.tv),
            title: Text('TV Series'),
            onTap: () => _navigate(context, HomeTVPage.routeName),
          ),
          ListTile(
            key: Key('drawer_watchlist_movies'),
            leading: Icon(Icons.save_alt),
            title: Text('Watchlist Movies'),
            onTap: () => _navigate(context, WatchlistMoviesPage.routeName),
          ),
          ListTile(
            key: Key('drawer_watchlist_tvs'),
            leading: Icon(Icons.playlist_add_check),
            title: Text('Watchlist TV Series'),
            onTap: () => _navigate(context, WatchlistTVsPage.routeName),
          ),
          ListTile(
            key: Key('drawer_about'),
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () => _navigate(context, AboutPage.routeName),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pop(context);
    if (routeName != currentRoute) {
      Navigator.pushNamed(context, routeName);
    }
  }
}
