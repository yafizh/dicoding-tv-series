import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv_series/presentation/pages/search_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mock_blocs.dart';

void main() {
  late MockTVSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTVSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListLoading());

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display the search result when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(TVListHasData(<TV>[testTV]));

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Game of Thrones'), findsOneWidget);
  });

  testWidgets('Should trigger a remote search when a query is submitted', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(const TVListEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));
    await tester.enterText(find.byKey(Key('query_input')), 'game of thrones');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    verify(() => mockBloc.add(const FetchTVSearch('game of thrones')))
        .called(1);
  });
}
