import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_insta/backends/api_movie.dart';
import 'package:movie_insta/backends/network_adapter.dart';
import 'package:movie_insta/constants/strings.dart';
import 'package:movie_insta/constants/text_styles.dart';
import 'package:movie_insta/providers/movie_list.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> moveToIndex() async {
    await fetchData().then((_) {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  Future<void> fetchData() async {
    final _movies = Provider.of<MovieList>(context, listen: false);
    final _api = MovieAPI(networkAdapter: NetworkAdapter());
    await _api.fetchMovies().then((movies) {
      _movies.initList(movies);
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1000), () async {
      await moveToIndex();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(Strings.splash_logo, style: TextStyles.splash_logo))
        ],
      ),
    );
  }
}
