import 'package:flutter/material.dart';
import 'package:movie_insta/constants/colors.dart';
import 'package:movie_insta/constants/strings.dart';
import 'package:movie_insta/constants/text_styles.dart';
import 'package:movie_insta/providers/movie_list.dart';
import 'package:movie_insta/views/tabs/tab_like.dart';
import 'package:movie_insta/views/tabs/tab_main.dart';
import 'package:movie_insta/views/tabs/tab_search.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    final _movies = Provider.of<MovieList>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorMap.black80,
        iconTheme: IconThemeData(color: ColorMap.white),
        elevation: 0,
        title: Row(
          children: [Text(_title(_currentIndex), style: TextStyles.title)],
        ),
      ),
      backgroundColor: ColorMap.black80,
      body: _body(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorMap.black80,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: ColorMap.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 22,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        unselectedItemColor: ColorMap.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 30), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30), label: ''),
        ],
      ),
    );
  }

  Widget _body(int index) {
    switch (index) {
      case 0:
        return MainTab();
      case 1:
        return LikeTab();
      case 2:
        return SearchTab();
      default:
        return MainTab();
    }
  }

  String _title(int index) {
    switch (index) {
      case 0:
        return Strings.title_main;
      case 1:
        return Strings.title_like;
      case 2:
        return Strings.title_search;
      default:
        return Strings.title_main;
    }
  }
}
