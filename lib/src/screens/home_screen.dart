import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/album/album_bloc.dart';
import '../blocs/album/album_event.dart';
import '../blocs/album/album_state.dart';
import '../constants/constants.dart' as constants;
import '../widgets/album_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AlbumBloc>().add(AlbumRequested());
    return Scaffold(
      appBar: AppBar(
        title: Text(constants.HomeScreen.appBarTitle),
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AlbumLoadFailure) {
            return Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Text(state.errorMessage!),
            );
          }
          if (state is AlbumLoadSucess) {
            return ListView(
              children: [
                for (var album in state.albums!)
                  Center(
                    child: AlbumCard(
                      album: album,
                    ),
                  )
              ],
            );
          }
          return Container(
            color: Colors.orange,
          );
        },
      ),
    );
  }
}
