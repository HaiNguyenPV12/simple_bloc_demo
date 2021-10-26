import 'package:flutter/material.dart';

import '../models/Album.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;
  const AlbumCard({
    Key? key,
    required this.album,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = false;
    double screenWidth = MediaQuery.of(context).size.width;
    isBigScreen = screenWidth > 500;

    double cardWidth = 250;

    if (isBigScreen) {
      cardWidth = 450;
    }
    return SizedBox(
      width: cardWidth,
      child: Card(
          child: ColoredBox(
        color: isBigScreen ? Colors.grey : Colors.teal,
        child: InkWell(
          onTap: onTap,
          child: Column(children: [
            Text(album.title!),
            Image.network(album.thumbnailUrl!,
                errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.green,
                      width: 100,
                      height: 50,
                    ))
          ]),
        ),
      )),
    );
  }
}
