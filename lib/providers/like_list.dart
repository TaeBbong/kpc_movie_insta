import 'package:flutter/material.dart';
import 'package:movie_insta/models/movie.dart';

class LikeList with ChangeNotifier {
  List<Movie> movies;

  LikeList({required this.movies});

  void addMovie(Movie movie) {
    this.movies.add(movie);
    notifyListeners();
  }

  void deleteMovie(int id) {
    this.movies.removeWhere((movie) => movie.id == id);
    notifyListeners();
  }
}
