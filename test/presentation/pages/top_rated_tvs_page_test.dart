import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/pages/top_rated_tvs_page.dart';

import '../../helpers/mock_blocs.dart';

void main() {
  late MockTopRatedTVsBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should fetch the list when opened', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListEmpty());

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    verify(() => mockBloc.add(const FetchTVList())).called(1);
  });

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListHasData(<TV>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    expect(textFinder, findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
