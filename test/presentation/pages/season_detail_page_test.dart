import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/presentation/pages/season_detail_page.dart';
import 'package:tv_series/presentation/provider/season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'season_detail_page_test.mocks.dart';

@GenerateMocks([SeasonDetailNotifier])
void main() {
  late MockSeasonDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockSeasonDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<SeasonDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display the episode list when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.seasonDetail).thenReturn(testSeasonDetail);

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byKey(Key('episode_list')), findsOneWidget);
    expect(find.text('Episodes'), findsOneWidget);
    expect(find.text('E1 • Winter Is Coming'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Server Failure');

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byKey(Key('error_message')), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });
}
