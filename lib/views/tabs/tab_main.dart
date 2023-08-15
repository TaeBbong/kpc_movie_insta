import 'package:flutter/material.dart';
import 'package:movie_insta/providers/movie_list.dart';
import 'package:movie_insta/views/widgets/movie_tile.dart';
import 'package:provider/provider.dart';

class MainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _movieList = Provider.of<MovieList>(context, listen: false);
    return ListView.builder(
      itemCount: _movieList.movies.length,
      itemBuilder: ((context, index) {
        return MovieTile(movie: _movieList.movies[index]);
      }),
    );
  }
}
