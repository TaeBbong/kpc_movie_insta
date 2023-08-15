import 'package:flutter/material.dart';
import 'package:movie_insta/providers/like_list.dart';
import 'package:movie_insta/views/widgets/movie_grid.dart';
import 'package:provider/provider.dart';

class LikeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _likes = Provider.of<LikeList>(context, listen: false);
    return GridView.count(
      crossAxisCount: 3,
      children: _likes.movies.map((movie) => MovieGrid(movie: movie)).toList(),
    );
  }
}
