import 'package:flutter/material.dart';
import 'package:movie_insta/models/movie.dart';

class MovieList with ChangeNotifier {
  List<Movie> movies;

  MovieList({required this.movies});

  void initList(List<Movie> movies) {
    this.movies = movies;
    notifyListeners();
  }

  void updateMovieLike(Movie movie) {
    this.movies[this.movies.indexWhere((e) => e.id == movie.id)] = movie;
    notifyListeners();
  }

  void addMovie(Movie movie) {
    this.movies.add(movie);
    notifyListeners();
  }

  void deleteMovie(int id) {
    this.movies.removeWhere((movie) => movie.id == id);
    notifyListeners();
  }
}
