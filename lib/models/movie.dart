import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String coverImg;
  final String summary;
  final int year;
  final double rating;
  final List<dynamic> genres;
  final bool like;

  Movie({
    required this.id,
    required this.title,
    required this.coverImg,
    required this.summary,
    required this.year,
    required this.rating,
    required this.genres,
    required this.like,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      coverImg,
      summary,
      year,
      rating,
      genres,
      like,
    ];
  }

  @override
  String toString() => "Movie<$id, $title, $like>";

  Movie copyWith({
    int? id,
    String? title,
    String? coverImg,
    String? summary,
    int? year,
    double? rating,
    List<dynamic>? genres,
    bool? like,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImg: coverImg ?? this.coverImg,
      summary: summary ?? this.summary,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      genres: genres ?? this.genres,
      like: like ?? this.like,
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      coverImg: map['large_cover_image'],
      summary: map['summary'],
      year: map['year'],
      rating: map['rating'].toDouble(),
      genres: map['genres'],
      like: false,
    );
  }
}
