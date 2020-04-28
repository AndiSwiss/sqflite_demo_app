import 'package:flutter/material.dart';

import 'package:sqflitedemoapp/database_helper.dart';
import 'package:sqflitedemoapp/movie.dart';
import 'package:sqflitedemoapp/raw_query.dart';

void main() => runApp(MyApp());

/// @author: Andreas Ambühl, https://github.com/AndiSwiss
///
/// Test-application for getting to know how the sqflite actually works,
/// including all CRUD-operations, executing any possible SQlite-statement,
/// database-migrations and more.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  // TODO: Try to have the movies inside the app:
//  final List<Movie> movies = List();

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                'NOTE: All output is shown in the console.',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'add a movie',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _insert();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'query all',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _query();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'update first',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _update();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'delete one',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _delete();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'rate first',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _rateMovie();
                  },
                ),
              ],
            ),
            Divider(
              thickness: 2,
              indent: 100,
              endIndent: 100,
            ),
            RawQuery(),
          ],
        ),
      ),
    );
  }

  // ------------------------ //
  // Button onPressed methods //
  // ------------------------ //

  void _insert() async {
    final id1 = await dbHelper.insert(exampleMovie1());
    if (id1 == -1) {
      final id2 = await dbHelper.insert(exampleMovie2());
//      if (id2 == -1) {
//        print('No movie was added (all movies are already in the db).');
//      }
    }
  }

  void _query() async {
    final allMovies = await dbHelper.getAllMovies();
    print('Query all movies:');
    allMovies.forEach((movie) => print(movie));
  }

  void _update() async {
    // First check, whether the movie is already updated
    final correctedTitle = 'Pretty Woman';
    final id = exampleMovie1().id;
    final Movie movie = await dbHelper.getMovie(id);
    if (movie == null) {
      print('The movie was not updated, because it is not in the db!');
    } else if (movie.title == correctedTitle) {
      print('The movie is already updated!');
    } else {
      movie.title = correctedTitle;
      final moviesAffected = await dbHelper.update(movie);
      print('Updated $moviesAffected movies(s), corrected '
          'title: $correctedTitle');
    }
  }

  void _delete() async {
//    final id = await dbHelper.getCount();
    final id = exampleMovie1().id;
    final moviesDeleted = await dbHelper.delete(id);
    if (moviesDeleted > 0) {
      print('Deleted $moviesDeleted movies(s): movie-id $id.');
    } else {
      final id2 = exampleMovie2().id;
      final moviesDeleted2 = await dbHelper.delete(id2);
      if (moviesDeleted2 > 0) {
        print('Deleted $moviesDeleted2 movies(s): movie-id $id2.');
      } else {
        print('No movie was deleted.');
      }
    }
  }

  void _rateMovie() async {
    final id = exampleMovie1().id;
    final Movie movie = await dbHelper.getMovie(id);
    if (movie == null) {
      print('Movie can\'t be rated, because it\'s not in the db.');
    } else if (movie.abstractness == 20.0) {
      print('The movie is already rated.');
    } else {
      movie.abstractness = 20.0;
      movie.cinematography = 75.4;
      movie.romanticness = 40.2;
      movie.complexity = 0.0;
      movie.darkness = 100.0;
      movie.humor = 50.04;
      movie.realism = 30.324532;
      movie.suspense = 23.34;
      movie.wokeness = 14.14;
      final moviesAffected = await dbHelper.update(movie);
      print('Successfully rated $moviesAffected movie(s).');
    }
  }

  /// Provides an exampleMovie
  /// (not yet rated, and with a intentionally wrong title)
  Movie exampleMovie1() {
    return Movie(
        id: 114,
        title: 'Prötti Wämün',
        posterUrl: 'hMVMMy1yDUvdufpTl8J8KKNYaZX.jpg',
        releaseDate: DateTime(1990, 3, 23),
        description:
            'When a millionaire wheeler-dealer enters a business contract with '
            'a Hollywood hooker Vivian Ward, he loses his heart in the '
            'bargain.');
  }

  /// Provides another exampleMovie (not yet rated)
  Movie exampleMovie2() {
    return Movie(
        id: 545609,
        title: 'Extraction',
        posterUrl: 'wlfDxbGEsW58vGhFljKkcR5IxDj.jpg',
        releaseDate: DateTime(2020, 4, 24),
        description:
            'Tyler Rake, a fearless mercenary who offers his services on the '
            'black market, embarks on a dangerous mission when he is hired '
            'to rescue the kidnapped son of a Mumbai crime lord...');
  }
}
