import 'package:flutter/material.dart';
import 'package:movie_insta/models/movie.dart';
import 'package:movie_insta/models/parameters.dart';

class MovieGrid extends StatelessWidget {
  Movie movie;
  MovieGrid({required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/detail', arguments: ScreenParameter(movie: movie));
      },
      child: Image.network(movie.coverImg, fit: BoxFit.fill),
    );
  }
}
