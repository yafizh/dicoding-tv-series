import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv_series/presentation/pages/home_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/mock_blocs.dart';

void main() {
  late MockOnTheAirTVsBloc mockOnTheAirBloc;
  late MockPopularTVsBloc mockPopularBloc;
  late MockTopRatedTVsBloc mockTopRatedBloc;

  setUp(() {
    mockOnTheAirBloc = MockOnTheAirTVsBloc();
    mockPopularBloc = MockPopularTVsBloc();
    mockTopRatedBloc = MockTopRatedTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnTheAirTVsBloc>.value(value: mockOnTheAirBloc),
        BlocProvider<PopularTVsBloc>.value(value: mockPopularBloc),
        BlocProvider<TopRatedTVsBloc>.value(value: mockTopRatedBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  void arrangeState(TVListState state) {
    when(() => mockOnTheAirBloc.state).thenReturn(state);
    when(() => mockPopularBloc.state).thenReturn(state);
    when(() => mockTopRatedBloc.state).thenReturn(state);
  }

  testWidgets('Page should fetch every section when opened', (
    WidgetTester tester,
  ) async {
    arrangeState(const TVListEmpty());

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    verify(() => mockOnTheAirBloc.add(const FetchTVList())).called(1);
    verify(() => mockPopularBloc.add(const FetchTVList())).called(1);
    verify(() => mockTopRatedBloc.add(const FetchTVList())).called(1);
  });

  testWidgets('Page should display a progress bar per section when loading', (
    WidgetTester tester,
  ) async {
    arrangeState(const TVListLoading());

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display the three sections when data is loaded', (
    WidgetTester tester,
  ) async {
    arrangeState(TVListHasData(<TV>[testTV]));

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.byType(TVList), findsNWidgets(3));
  });

  testWidgets('Page should display Failed when a section errors', (
    WidgetTester tester,
  ) async {
    arrangeState(const TVListError('Server Failure'));

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });
}
