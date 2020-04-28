import 'package:flutter/material.dart';

import 'package:sqflitedemoapp/database_helper.dart';
import 'package:sqflitedemoapp/movie.dart';
import 'package:sqflitedemoapp/raw_query.dart';

void main() => runApp(MyApp());

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
                    'add movie',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _insert();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'query all',
                    style: TextStyle(fontSize: 20),
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
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _update();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'delete one',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _delete();
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

  // Button onPressed methods

  void _insert() async {
    final id1 = exampleMovie1().id;
    final Movie movie1 = await dbHelper.getMovie(id1);
    if (movie1 == null) {
      final id = await dbHelper.insert(exampleMovie1());
      print('Inserted movie id: $id');
    } else {
      final id2 = exampleMovie2().id;
      final Movie movie2 = await dbHelper.getMovie(id2);
      if (movie2 == null) {
        final id = await dbHelper.insert(exampleMovie2());
        print('Inserted movie id: $id');
      } else {
        print('No movie was added (all movies are already in the db).');
      }
    }
  }

  void _query() async {
    final allRows = await dbHelper.getAllMovies();
    print('Query all rows:');
    allRows.forEach((row) => print(row));
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
      final rowsAffected = await dbHelper.update(movie);
      print('Updated $rowsAffected row(s), corrected title: $correctedTitle');
    }
  }

  void _delete() async {
//    final id = await dbHelper.getCount();
    final id = exampleMovie1().id;
    final rowsDeleted = await dbHelper.delete(id);
    if (rowsDeleted > 0) {
      print('Deleted $rowsDeleted row(s): movie-id $id.');
    } else {
      final id2 = exampleMovie2().id;
      final rowsDeleted2 = await dbHelper.delete(id2);
      if (rowsDeleted2 > 0) {
        print('Deleted $rowsDeleted2 row(s): movie-id $id2.');
      } else {
        print('No movie was deleted.');
      }
    }
  }

  Movie exampleMovie1() {
    return Movie(
        id: 114,
        title: 'Prötti Wämün',
        posterUrl: 'hMVMMy1yDUvdufpTl8J8KKNYaZX.jpg',
        releaseDate: DateTime(1990, 3, 23),
        description:
            'When a millionaire wheeler-dealer enters a business contract with a Hollywood hooker Vivian Ward, he loses his heart in the bargain.');
  }

  Movie exampleMovie2() {
    return Movie(
        id: 545609,
        title: 'Extraction',
        posterUrl: 'wlfDxbGEsW58vGhFljKkcR5IxDj.jpg',
        releaseDate: DateTime(2020, 4, 24),
        description:
            'Tyler Rake, a fearless mercenary who offers his services on the black market, embarks on a dangerous mission when he is hired to rescue the kidnapped son of a Mumbai crime lord...');
  }
}
