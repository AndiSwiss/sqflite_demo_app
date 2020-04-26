import 'package:flutter/Material.dart';

class Movie {
  int id;
  String title;
  DateTime releaseDate;
  String description;
  String posterUrl;
  Image poster;
  double abstractness = 50;
  double cinematography = 50;
  double romanticness = 50;
  double complexity = 50;
  double darkness = 50;
  double humor = 50;
  double realism = 50;
  double suspense = 50;
  double wokeness = 50;

  Movie(
      {this.id,
      this.title,
      this.posterUrl,
      this.releaseDate,
      this.description}) {
    if (this.posterUrl != null) {
      this.posterUrl = "https://image.tmdb.org/t/p/w342" + this.posterUrl;
      this.poster = Image.network(posterUrl);
    }
    //Placeholder => should be cached offline => temporary
    else
      this.poster = Image(image: AssetImage("assets/empty.png"));
  }

  // Named constructor for database-operation (needed by database_helper.dart),
  // see also:
  // https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Movie.map(dynamic obj) {
    this.id = obj['id'];
    this.title = obj['title'];
    this.posterUrl = obj['posterUrl'];
    this.releaseDate = obj['releaseDate'];
    this.description = obj['description'];
    if (this.posterUrl != null) {
      this.posterUrl = "https://image.tmdb.org/t/p/w342" + this.posterUrl;
      this.poster = Image.network(posterUrl);
    }
    // todo: the same for 9 parameters like abstractness -> maybe combined in one string!)
  }

  // Named constructor for database-operation (needed by database_helper.dart),
  // see also:
  // https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Movie.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.posterUrl = map['posterUrl'];
    this.releaseDate = map['releaseDate'];
    this.description = map['description'];
    if (this.posterUrl != null) {
      this.posterUrl = "https://image.tmdb.org/t/p/w342" + this.posterUrl;
      this.poster = Image.network(posterUrl);
    }
    // todo: the same for 9 parameters like abstractness -> maybe combined in one string!)
  }

  // For database-operation (needed by database_helper.dart), see also:
  // https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['posterUrl'] = posterUrl;
    map['releaseDate'] = releaseDate;
    map['description'] = description;
    // todo: the same for 9 paramaters like abstractness -> maybe combined in one string!)
  }
}