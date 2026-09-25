import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/season_detail/season_detail_bloc.dart';
import 'package:tv_series/presentation/pages/season_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mock_blocs.dart';

void main() {
  late MockSeasonDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockSeasonDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SeasonDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should fetch the season detail when opened', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const SeasonDetailEmpty());

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 2)),
    );

    verify(() => mockBloc.add(const FetchSeasonDetail(1, 2))).called(1);
  });

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const SeasonDetailLoading());

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display the episode list when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(SeasonDetailHasData(testSeasonDetail));

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
    when(() => mockBloc.state)
        .thenReturn(const SeasonDetailError('Server Failure'));

    await tester.pumpWidget(
      makeTestableWidget(SeasonDetailPage(tvId: 1, seasonNumber: 1)),
    );

    expect(find.byKey(Key('error_message')), findsOneWidget);
    expect(find.text('Server Failure'), findsOneWidget);
  });
}
