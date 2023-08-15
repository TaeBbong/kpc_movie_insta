import 'dart:convert';

import 'network_adapter.dart';
import 'package:movie_insta/models/movie.dart';

class MovieAPI {
  final NetworkAdapter networkAdapter;
  MovieAPI({required this.networkAdapter});

  // GET /v2/list_movies.json 영화 전체 조회
  Future<List<Movie>> fetchMovies() async {
    final response = await networkAdapter.get(path: '/', params: {});
    final List<dynamic> list =
        jsonDecode(utf8.decode(response.bodyBytes))['data']['movies'];
    return list.map((e) => Movie.fromMap(e)).toList();
  }
}
