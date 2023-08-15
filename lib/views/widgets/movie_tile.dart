import 'package:flutter/material.dart';
import 'package:movie_insta/constants/colors.dart';
import 'package:movie_insta/constants/text_styles.dart';
import 'package:movie_insta/models/movie.dart';
import 'package:movie_insta/models/parameters.dart';
import 'package:movie_insta/providers/like_list.dart';
import 'package:movie_insta/providers/movie_list.dart';
import 'package:provider/provider.dart';

class MovieTile extends StatefulWidget {
  Movie movie;
  MovieTile({required this.movie});
  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  late bool _like = widget.movie.like;
  @override
  void initState() {
    super.initState();
    _like = widget.movie.like;
  }

  @override
  Widget build(BuildContext context) {
    final _likes = Provider.of<LikeList>(context, listen: false);
    final _movies = Provider.of<MovieList>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.movie.title,
                style: TextStyles.white_24,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.movie.coverImg,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: InkWell(
                    child: _like
                        ? Icon(Icons.favorite, color: ColorMap.red_heart)
                        : Icon(Icons.favorite_border, color: Colors.white),
                    onTap: () {
                      setState(() {
                        _like = !_like;
                        _movies.updateMovieLike(
                            widget.movie.copyWith(like: _like));
                        if (_like == true) {
                          _likes.addMovie(widget.movie);
                        } else {
                          _likes.deleteMovie(widget.movie.id);
                        }
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                widget.movie.summary,
                style: TextStyles.white_16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Divider(
                color: ColorMap.grey,
                thickness: 1.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
