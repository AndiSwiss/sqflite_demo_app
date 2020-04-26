import 'package:flutter/material.dart';

import 'package:sqflitedemoapp/database_helper.dart';
import 'package:sqflitedemoapp/movie.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insert();
              },
            ),
            RaisedButton(
              child: Text(
                'query',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _query();
              },
            ),
            RaisedButton(
              child: Text(
                'update',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _update();
              },
            ),
            RaisedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    print('my example movie (with .toMap): ${exampleMovie().toMap()}');
    final id = await dbHelper.insert(exampleMovie());
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.getAllMovies();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _update() async {
    final rowsAffected = await dbHelper.update(updatedMovie());
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
//    final id = await dbHelper.getCount();
    final id = 114;
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): movie-id $id');
  }

  Movie exampleMovie() {
    return Movie(
        id: 114,
        title: 'Prötti Wämün',
        posterUrl: 'hMVMMy1yDUvdufpTl8J8KKNYaZX.jpg',
        releaseDate: DateTime(1990, 1, 1),
        description:
            'When a millionaire wheeler-dealer enters a business contract with a Hollywood hooker Vivian Ward, he loses his heart in the bargain.');
  }

  Movie updatedMovie() {
    return Movie(
        id: 114,
        title: 'Pretty Woman',
        posterUrl: 'hMVMMy1yDUvdufpTl8J8KKNYaZX.jpg',
        releaseDate: DateTime(1990, 1, 1),
        description:
            'When a millionaire wheeler-dealer enters a business contract with a Hollywood hooker Vivian Ward, he loses his heart in the bargain.');
  }
}
