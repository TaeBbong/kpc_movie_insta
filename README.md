# 영화 정보 조회 앱 구현

프로그라피 `Flutter` 분야 선발 과제인 영화 정보 조회 앱입니다.
인스타그램을 모티브로 UI를 제작하였습니다.

## 사용 기술 스택 설명

- `Flutter`: 2.10.0
- `Equatable`: 2.0.5
- `Provider`: 6.0.5

## 데모

<img src="./assets/images/moviestagram_demo.gif"  height=70%>

## 기능 설명

### 0. 구현한 기능 목록 및 프로젝트 전반 설계 방식

- [UI] 스플래시 화면
- [UI] 영화 목록 화면
- [UI] 좋아요 한 영화 목록 화면
- [UI] 검색 화면
- [기능] 비동기로 데이터 가져온 후 다음 화면 이동 기능
- [기능] 좋아요 기능 및 관련 상태 관리

프로젝트 내 디렉토리 구조는 다음과 같습니다.

```bash
├── assets # 정적인 asset(font, images) 디렉토리
│   ├── fonts
│   └── images
│       └── moviestagram_demo.gif
├── lib
│   ├── backends # 백엔드 연동을 위한 디렉토리
│   │   ├── api_movie.dart # movie api 연동부분
│   │   └── network_adapter.dart # 모든 프로젝트에서 활용할 수 있는 HTTP 처리 클래스
│   ├── constants # 프로젝트에서 사용되는 각종 상수 값 및 스타일
│   │   ├── colors.dart
│   │   ├── strings.dart
│   │   └── text_styles.dart
│   ├── main.dart
│   ├── models # 객체로 다루게 되는 모델들
│   │   ├── movie.dart
│   │   └── parameters.dart
│   ├── providers # 상태관리가 필요한 모델들
│   │   ├── like.dart
│   │   └── movie_list.dart
│   └── views # UI 영역
│       ├── pages # 화면 단위
│       │   ├── page_detail.dart
│       │   ├── page_home.dart
│       │   └── page_splash.dart
│       ├── tabs # 탭 단위
│       │   ├── tab_like.dart
│       │   ├── tab_main.dart
│       │   └── tab_search.dart
│       └── widgets # 위젯 단위
│           ├── movie_grid.dart
│           └── movie_tile.dart
```

프로젝트는 기본적으로 `Provider` 패턴을 활용하여 작성했으며, 그동안 `Flutter`로 개발하며 가장 효율적인 분리라고 생각된 구조인 `views`, `models`, `providers`, `backends`로 기능 파일들을 분리하여 작성했습니다.

### 1. 백엔드 기능 구현

제시된 API 주소를 활용하여 데이터를 가져오는 기능이 필요했습니다.
이후 프로젝트의 확장성을 고려하여 `network_adapter`를 통해 `GET` 외 다른 메소드를 처리할 수 있도록 하였으며, 이는 어떤 프로젝트에서도 가져다 쓸 수 있는 모듈 같은 파일입니다.

```dart
// lib/backends/network_adapter.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum Environ { DEV, PROD }

class NetworkAdapter {
  String baseURL = "";
  Environ env = Environ.DEV;

  NetworkAdapter() {
    env == Environ.DEV
        ? baseURL = "https://yts.mx/api/v2/list_movies.json"
        : baseURL = "https://yts.mx/api/v2/list_movies.json";
  }

  Future<dynamic> get(
      {required String path,
      required Map<String, dynamic> params,
      String? token}) async {
    String urlStr = this.baseURL + path;
    if (params != {}) {
      urlStr += "?";
      for (var key in params.keys) {
        urlStr += '$key=${params[key]}&';
      }
    }
    final url = Uri.parse(urlStr);
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-AUTH-TOKEN': '$token'
    });
    return response;
  }

  Future<dynamic> post() {
    ...
  }

  Future<dynamic> put() {
    ...
  }

  Future<dynamic> patch() {
    ...
  }

  Future<dynamic> delete() {
    ...
  }

}
```

`api_movie`는 본 프로젝트에서 영화 목록을 가져오기 위한 함수를 구현한 파일입니다.
앞서 `network_adapter`를 통해 `GET` 메소드를 구현했기 때문에 코드를 간단히 작성할 수 있었습니다.

```dart
// lib/backends/api_movie.dart
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
```

### 2. 모델

`models` 디렉토리에는 `movie`와 `parameters`가 있지만, `parameters`는 이후 `routes`를 기반으로 화면을 이동할 때 데이터를 전달해주기 위한 모델로 데이터를 추상화한 모델은 `movie`만 해당됩니다.
API를 기반으로 필요한 필드를 모델로 선언해주고, 몇가지 메소드를 정의하였습니다.

```dart
// lib/models/movie.dart
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
    ...
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      ...
    ];
  }

  @override
  String toString() => "Movie<$id, $title, $like>";

  Movie copyWith({
    int? id,
    String? title,
    ...
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      ...
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      ...
    );
  }
}
```

`Equatable` 패키지를 활용하여 오브젝트 비교 등 관리를 편하게 할 수 있도록 하였습니다.
`toString()`을 통해 개발간 데이터 출력시 보기 좋게 만들었습니다.
`copyWith()`을 통해 final로 정의한 필드를 업데이트할 수 있으며, 이때 업데이트하고자 하는 필드만 업데이트 되도록 구현했습니다.
`fromMap()`은 `Map<String, dynamic>` 데이터를 `Movie` 객체로 변환시켜주는 직렬화 함수입니다.

### 3. Provider 기반 상태관리

`Provider`는 제가 생각하기에 가장 쉬운 `Flutter` 상태관리 도구입니다.
본 프로젝트처럼 간단한 구조의 프로젝트는 `Provider`를 통해 전역 상태관리를 구현하고 생산성을 높일 수 있습니다.

프로젝트에서 다룬 전역 상태는 전체 영화 목록(`movie_list`)와 좋아요한 영화 목록(`like`)입니다. 
이들을 전역으로 관리하여 좋아요를 누르고 다른 페이지를 갔다와도 좋아요 상태가 유지되도록 처리했습니다.
화면 내에서 좋아요 버튼의 상태는 `setState()`로 처리하여 빠르게 개발했는데, 조금 더 여유가 있다면 전부 `StatelessWidget`으로 바꾸고 좋아요 버튼 또한 `Provider`로 관리되도록 작성할 수 있을 것입니다. 

`Provider`로 관리하기 위해 `ChangeNotifier`를 활용한 구현 예시는 다음과 같습니다.

```dart
// lib/providers/like_list.dart
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
```

`Provider`는 전역에서 관리되도록 `main.dart`의 `MaterialApp`에서 선언하였습니다.

```dart
// lib/main.dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieList(movies: [])),
        ChangeNotifierProvider(create: (_) => LikeList(movies: [])),
      ],
      builder: (context, child) {
        return MaterialApp(
          ...
```

### 4. SplashPage 활용 비동기 데이터 가져오기

Splash 화면은 앱 로고를 보여주면서 시간이 필요한 작업을 처리할 때 활용됩니다.
프로젝트에서는 이를 활용해 백엔드로부터 데이터를 가져오도록 하고, 다 가져오면 홈 화면으로 이동하도록 처리했습니다.

```dart
// lib/views/pages/page_splash.dart
import 'dart:async';
...

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

  ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ...
    );
  }
}
```

### 5. 화면 전환(route)

화면 전환은 `MaterialApp`의 `routes`를 활용하여 관리가 용이하게 작성했습니다.

```dart
// lib/main.dart
...
      builder: (context, child) {
        return MaterialApp(
          title: 'Moviestagram',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/home': (context) => HomePage(),
            '/detail': (context) => DetailPage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
...
```

이때 `DetailPage`의 경우 `Movie` 객체를 전달받아야 합니다. 
이를 위해 `ScreenParameter` 클래스를 선언하고, 받는 페이지인 `DetailPage`에서 이를 처리하도록 구현했습니다. 

```dart
// lib/models/parameters.dart
import 'package:movie_insta/models/movie.dart';

class ScreenParameter {
  Movie movie;
  ScreenParameter({required this.movie});
}
```

```dart
// lib/views/pages/page_detail.dart
...
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScreenParameter params =
        ModalRoute.of(context)!.settings.arguments as ScreenParameter;
    return Scaffold(
      appBar: AppBar(
        ...
```

### 6. 좋아요 기능

좋아요 기능은 다음과 같은 절차로 동작합니다.

1. `MovieTile`에 있는 좋아요 버튼을 누른다.
2. 이는 `setState()`로 관리되어 즉각적으로 변화가 화면에 적용된다.
3. 이때, 전역으로 관리되는 `MovieList`와 `LikeList`를 업데이트 한다.

```dart
// lib/views/widgets/movie_tile.dart
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
    ...
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
    ...
```

### 7. 화면 구성

UI 구현에서는 특별히 설명할 부분은 없었습니다.
`BottomNavigationBar` 구조를 활용하여 인스타그램과 같은 앱 구조를 보이도록 하였고, 내부 body는 `Tab`의 형태로 작성했습니다.

```dart
// lib/views/pages/page_home.dart
...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ...
      body: _body(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        ...
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        ...
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
      ...
    }
  }
  ...
```

### 8. 위젯 분리

화면 구성에서 사용되는 `MovieTile`과 `MovieGrid`를 `widgets` 디렉토리에 나눠서 구현했습니다.
이 덕분에 `Tab` 파일들의 코드가 짧아졌습니다.

### 9. 상수 값들 분리

협업 및 유지보수, 스타일 규격 통일 등을 위해 각종 스타일 및 문자열을 분리했습니다.
이를 통해 앱 UI 구현시 스타일 적용을 좀 더 쉽게 할 수 있을 것입니다.

```dart
// lib/constants/text_styles.dart
import 'package:flutter/material.dart';
import 'package:movie_insta/constants/colors.dart';

class TextStyles {
  static const splash_logo = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, color: ColorMap.black80);
  static const title = TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: ColorMap.white);
  static const white_16_bold =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);
    ...
```