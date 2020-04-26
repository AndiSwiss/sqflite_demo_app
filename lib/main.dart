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
    // TODO: the problem is, that my movie is null!!!! -> repair that!
    print('my example movie: ${exampleMovie().toMap()}');
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
    final id = 15;
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }

  Movie exampleMovie() {
    return Movie(
        id: 15,
        title: 'Prötti Wämün',
        posterUrl: 'https://google.com/pretty_woman',
        releaseDate: DateTime(1970, 4, 20),
        description: 'nice move');
  }

  Movie updatedMovie() {
    return Movie(
        id: 15,
        title: 'Pretty Woman',
        posterUrl: 'https://google.com/pretty_woman',
        releaseDate: DateTime(1970, 4, 20),
        description: 'nice move');
  }
}
