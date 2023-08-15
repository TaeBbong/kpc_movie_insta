import 'package:flutter/material.dart';
import 'package:movie_insta/providers/like_list.dart';
import 'package:movie_insta/providers/movie_list.dart';
import 'package:movie_insta/views/pages/page_home.dart';
import 'package:movie_insta/views/pages/page_splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieList(movies: [])),
        ChangeNotifierProvider(create: (_) => LikeList(movies: [])),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Moviestagram',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/home': (context) => HomePage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
