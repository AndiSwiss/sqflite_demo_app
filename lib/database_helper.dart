import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflitedemoapp/movie.dart';

/// @author: Andreas Ambühl, https://github.com/AndiSwiss
///
/// With some initial basic app structure from:
/// https://medium.com/@suragch/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
/// and for using a data-class, I also used parts from:
/// https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";

  // Version 2: I introduced new table-column 'ratings':
  static final _databaseVersion = 2;

  static final table = 'my_table';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnReleaseDate = 'releaseDate';
  static final columnDescription = 'description';
  static final columnPosterUrl = 'posterUrl';
  static final columnPoster = 'poster'; // Currently not yet used!
  static final columnRatings = 'ratings';

  // --------- //
  // Singleton //
  // --------- //

  /// Make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  /// Only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // -------------------------------------- //
  // Database-initialization, -migration... //
  // -------------------------------------- //

  /// This opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  /// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnReleaseDate TEXT,
            $columnDescription TEXT,
            $columnPosterUrl TEXT,
            $columnPoster BLOB,
            $columnRatings TEXT,
          )
          ''');
  }

  /// SQL code for migration:
  /// see also section "Migration" in:
  /// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
  /// and example here:
  /// https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute('ALTER TABLE $table ADD $columnRatings TEXT');
      print("Database upgraded from version 1 to version 2, added column "
          "'$columnRatings'");
    }
  }

  // ------------------------------- //
  // CRUD and other database-actions //
  // ------------------------------- //

  /// Inserts a movie in the database, but only if it is not already present!
  ///
  /// The return value is the id of the inserted movie,
  /// or -1 if the movie already existed.
  Future<int> insert(Movie movie) async {
    Database db = await instance.database;
    // First check, whether the movie already exists:
    final Movie existingMovie = await getMovie(movie.id);
    if (existingMovie != null) {
      print('Movie ${movie.id} already existed in the db and thus was '
          'not added.');
      return -1;
    } else {
      int answer = await db.insert(table, movie.toMap());
      print('Movie ${movie.id} inserted in the db.');
      return answer;
    }
  }

  /// Gets a list from the movies which are saved in the database.
  /// Returns the list of Movies
  Future<List<Movie>> getAllMovies() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.query(table);
    List<Movie> movies =
        list.map((rawMovie) => Movie.fromMap(rawMovie)).toList();
    return movies;
  }

  /// Gets a specific movie from the database.
  /// Returns the movie, or 'null' if the movie was not found.
  Future<Movie> getMovie(int id) async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT * FROM $table WHERE $columnId = $id');

    if (result.length > 0) {
      return new Movie.fromMap(result.first);
    }

    return null;
  }

  /// All of the methods (insert, query, update, delete) can also be done using
  /// raw SQL commands. This method uses a raw query to give the movie count.
  Future<int> getCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  /// Updates a movie.
  /// Returns the amount of movies updated.
  /// Returns 1 (or more) if the given movie was found. It does not report,
  /// whether it actually changed some data.
  /// Returns 0 if the given movie was not present in the db.
  Future<int> update(Movie movie) async {
    Database db = await instance.database;
    return await db.update(table, movie.toMap(),
        where: '$columnId = ?', whereArgs: [movie.id]);
  }

  /// Deletes the movie specified by the id.
  /// Returns the amount of deleted movies.
  /// Returns 0 if the given movie was not present in the db.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  /// Executes a raw SQL-Query as provided.
  /// Returns the answer of the query as a Future<List<Map<String, dynamic>>>.
  Future<List<Map<String, dynamic>>> executeRawQuery(String query) async {
    Database db = await instance.database;
    print('You entered: $query');
    try {
      return await db.rawQuery(query);
    } catch (e) {
      print('ERROR! You entered an invalid query!');
      print(e.toString());
      return null;
    }
  }
}
