import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_bloc_demo/src/models/Album.dart';
import 'package:simple_bloc_demo/src/widgets/album_card.dart';

main() {
  final albumId = 123;
  final id = 234;
  final albumTitle = 'albumTitle';
  final albumUrl = 'albumUrl';
  final thumbnailUrl = 'thumbnailUrl';
  final album = Album(
      albumId: albumId,
      id: id,
      title: albumTitle,
      url: albumUrl,
      thumbnailUrl: thumbnailUrl);

  final widget = MaterialApp(
    home: Scaffold(
      body: AlbumCard(
        album: album,
      ),
    ),
  );

  testWidgets('Should render card with title', (tester) async {
    await tester.pumpWidget(widget);

    final albumCardFinder = find.byType(AlbumCard);
    final albumTitleFinder =
        find.descendant(of: albumCardFinder, matching: find.text(albumTitle));

    expect(albumTitleFinder, findsOneWidget);
  });

  testWidgets('Should render grey card on big screen', (tester) async {
    tester.binding.window.physicalSizeTestValue = Size(2000, 500);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pumpWidget(widget);

    final albumCardFinder = find.byType(AlbumCard);
    final coloredSectionFinder =
        find.descendant(of: albumCardFinder, matching: find.byType(ColoredBox));

    expect((tester.firstWidget(coloredSectionFinder) as ColoredBox).color,
        Colors.grey);
  });

  testWidgets('AlbumCard should be tappable', (tester) async {
    bool isTapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AlbumCard(
          album: album,
          onTap: () {
            isTapped = true;
          },
        ),
      ),
    ));

    final albumCardFinder = find.byType(AlbumCard);
    await tester.tap(albumCardFinder);

    expect(isTapped, true);
  });
}
