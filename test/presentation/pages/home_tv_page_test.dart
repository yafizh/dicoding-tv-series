import 'package:tv_series/common/state_enum.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';
import 'package:tv_series/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TVListNotifier])
void main() {
  late MockTVListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVListNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display a progress bar per section when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.loading);
    when(mockNotifier.popularTVsState).thenReturn(RequestState.loading);
    when(mockNotifier.topRatedTVsState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display the three sections when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.loaded);
    when(mockNotifier.onTheAirTVs).thenReturn(<TV>[testTV]);
    when(mockNotifier.popularTVsState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularTVs).thenReturn(<TV>[testTV]);
    when(mockNotifier.topRatedTVsState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedTVs).thenReturn(<TV>[testTV]);

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(TVList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed when a section errors', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.error);
    when(mockNotifier.popularTVsState).thenReturn(RequestState.error);
    when(mockNotifier.topRatedTVsState).thenReturn(RequestState.error);

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });
}
