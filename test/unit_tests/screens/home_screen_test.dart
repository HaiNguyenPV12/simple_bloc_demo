import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_bloc.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_event.dart';
import 'package:simple_bloc_demo/src/blocs/album/album_state.dart';
import 'package:simple_bloc_demo/src/constants/constants.dart' as constants;
import 'package:simple_bloc_demo/src/models/Album.dart';
import 'package:simple_bloc_demo/src/screens/home_screen.dart';
import 'package:simple_bloc_demo/src/services/album_service/album_service.dart';
import 'package:simple_bloc_demo/src/widgets/album_card.dart';

import '../../mock_data/albums_mock_data.dart';

class MockAlbumBloc extends MockBloc<AlbumEvent, AlbumState>
    implements AlbumBloc {}

class MockAlbumService extends Mock implements AlbumService {}

class FakeAlbumState extends Fake implements AlbumState {}

class FakeAlbumEvent extends Fake implements AlbumEvent {}

main() {
  final mockResponse = json.decode(mockAlbumsData);

  setUpAll(() {
    registerFallbackValue(FakeAlbumState());
    registerFallbackValue(FakeAlbumEvent());
  });

  group('Home Screen Tests', () {
    late AlbumService albumService;
    late AlbumBloc albumBloc;
    var widget = MaterialApp(
      home: MultiBlocProvider(
          providers: [BlocProvider(create: (context) => albumBloc)],
          child: HomeScreen()),
    );

    setUp(() {
      albumService = MockAlbumService();
      albumBloc = MockAlbumBloc();
    });

    tearDown(() {
      albumBloc.close();
    });

    testWidgets('Should render Appbar with correct title', (tester) async {
      when(() => albumService.fetchAlbum())
          .thenAnswer((_) async => mockResponse);
      when(() => albumBloc.state).thenReturn(AlbumLoadInProgress());

      await tester.pumpWidget(widget);

      final titleFinder = find.descendant(
          of: find.byType(AppBar),
          matching: find.text(constants.HomeScreen.appBarTitle));

      expect(titleFinder, findsOneWidget);
    });

    testWidgets(
        'Should render progress indicator when album bloc state is [AlbumLoadInProgress]',
        (tester) async {
      when(() => albumBloc.state).thenReturn(AlbumLoadInProgress());
      await tester.pumpWidget(widget);
      await tester.pump();

      final indicatorFinder = find.byType(CircularProgressIndicator);
      expect(indicatorFinder, findsOneWidget);
    });

    testWidgets(
        'Should render red container with error message when album bloc state is [AlbumLoadFailure]',
        (tester) async {
      final errorMessage = 'errorMessage';
      when(() => albumBloc.state)
          .thenReturn(AlbumLoadFailure(errorMessage: errorMessage));
      await tester.pumpWidget(widget);
      await tester.pump();

      final errorMessageFinder = find.text(errorMessage);
      expect(errorMessageFinder, findsOneWidget);
      expect((tester.widget(find.byType(Container)) as Container).color,
          Colors.red);
    });

    testWidgets(
        'Should render orange container when Bloc emits uncovered state',
        (tester) async {
      when(() => albumBloc.state).thenReturn(FakeAlbumState());
      await tester.pumpWidget(widget);
      await tester.pump();

      expect((tester.widget(find.byType(Container)) as Container).color,
          Colors.orange);
    });

    testWidgets(
        'Should render AlbumCard list when bloc state is [AlbumLoadSucess]',
        (tester) async {
      when(() => albumBloc.state).thenReturn(AlbumLoadSucess(
          albums: List<Album>.from(
              mockResponse.map((model) => Album.fromJson(model)))));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final albumCardFinder = find.descendant(
          of: find.byType(ListView), matching: find.byType(AlbumCard));

      expect(albumCardFinder, findsWidgets);
    });
  });
}
