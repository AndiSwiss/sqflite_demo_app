import 'package:flutter/Material.dart';

/// Data class for a movie
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

  /// Basic constructor
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

  /// Named constructor for database-operation (needed by database_helper.dart),
  /// see also:
  /// https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Movie.map(dynamic obj) {
    this.id = obj['id'];
    this.title = obj['title'];
    try {
      String dateAsString = obj['releaseDate'];
      this.releaseDate = DateTime.parse(
        dateAsString,
      );
    } catch (e) {
      print(e);
    }
    this.description = obj['description'];
    this.posterUrl = obj['posterUrl'];
    if (this.posterUrl != null) {
      this.posterUrl = "https://image.tmdb.org/t/p/w342" + this.posterUrl;
      this.poster = Image.network(posterUrl);
    }
    // For the 9 rating-parameters like abstractness, ...:
    _convertStringToRatings(obj['ratings']);
  }

  /// Named constructor for database-operation (needed by database_helper.dart),
  /// see also:
  /// https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Movie.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    try {
      String dateAsString = map['releaseDate'];
      this.releaseDate = DateTime.parse(
        dateAsString,
      );
    } catch (e) {
      print(e);
    }
    this.description = map['description'];
    this.posterUrl = map['posterUrl'];
    if (this.posterUrl != null) {
      this.posterUrl = "https://image.tmdb.org/t/p/w342" + this.posterUrl;
      this.poster = Image.network(posterUrl);
    }
    // For the 9 rating-parameters like abstractness, ...:
    _convertStringToRatings(map['ratings']);
  }

  /// For database-operation (needed by database_helper.dart), see also:
  /// https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['releaseDate'] = releaseDate.toIso8601String();
    map['description'] = description;
    map['posterUrl'] = posterUrl;

    // For the 9 rating-parameters like abstractness, ...:
    map['ratings'] = _convertAllRatingsToOneString();

    return map;
  }

  /// For database-operations, because all the ratings are saved in one
  /// single string in the database
  String _convertAllRatingsToOneString() {
    return '$abstractness $cinematography $romanticness $complexity $darkness '
        '$humor $realism $suspense $wokeness';
  }

  /// For database-operations, because all the ratings are saved in one
  /// single string in the database
  void _convertStringToRatings(String string) {
    if (string == null) {
      return;
    }
    // Try with NO error handling -> it really should not occur, otherwise
    // as a dev, I should see the error!
//    try {
    List<double> individual = string.split(' ').map(double.parse).toList();
    abstractness = individual.removeAt(0);
    cinematography = individual.removeAt(0);
    romanticness = individual.removeAt(0);
    complexity = individual.removeAt(0);
    darkness = individual.removeAt(0);
    humor = individual.removeAt(0);
    realism = individual.removeAt(0);
    suspense = individual.removeAt(0);
    wokeness = individual.removeAt(0);
//    } catch (e) {
//      print('ERROR: ${e.toString()}');
//    }
  }

  /// For testing purposes, with some shortened strings
  @override
  String toString() {
    final int limit = 20;
    return 'Movie{id: $id, title: $title, releaseDate: $releaseDate, '
        'description: ${description.substring(0, limit)}..., '
        'posterUrl: ${posterUrl.substring(0, limit)}..., '
        'poster: ${poster.toString().substring(0, limit)}..., '
        'ratings: $abstractness $cinematography $romanticness '
        '$complexity $darkness $humor $realism $suspense $wokeness}';
  }
}
