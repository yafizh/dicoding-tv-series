import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/pages/search_tv_page.dart';
import 'package:tv_series/presentation/provider/tv_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_tv_page_test.mocks.dart';

@GenerateMocks([TVSearchNotifier])
void main() {
  late MockTVSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVSearchNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display the search result when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.searchResult).thenReturn(<TV>[testTV]);

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Game of Thrones'), findsOneWidget);
  });

  testWidgets('Should trigger a remote search when a query is submitted', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);

    await tester.pumpWidget(makeTestableWidget(SearchTVPage()));
    await tester.enterText(find.byKey(Key('query_input')), 'game of thrones');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    verify(mockNotifier.fetchTVSearch('game of thrones'));
  });
}
