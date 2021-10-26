import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/album/album_bloc.dart';
import 'screens/home_screen.dart';
import 'services/album_service/app_album_service.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AlbumBloc(
              service: AppAlbumService(httpClient),
            ),
          )
        ],
        child: HomeScreen(),
      ),
    );
  }
}
