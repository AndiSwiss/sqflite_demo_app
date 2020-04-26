import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflitedemoapp/movie.dart';

/// According to
/// https://medium.com/@suragch/simple-sqflite-database-example-in-flutter-e56a5aaa3f91
/// and for using a data-class, see
/// https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnReleaseDate = 'releaseDate';
  static final columnDescription = 'description';
  static final columnPosterUrl = 'posterUrl';
  static final columnPoster = 'poster';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);

    // NOTE: If a database-upgrade would be required, you can specify a method
    // inside the 'openDatabase'-call:  onUpgrade: _onUpgrade
    // then you can simply define that method
    // see also section "Migration" on
    // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
    // and examples on
    // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnReleaseDate TEXT
            $columnDescription TEXT
            $columnPosterUrl TEXT
            $columnPoster BLOB
          )
          ''');
  }

  // SQL code for migration:
  // More or less from
  // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // TODO: The following is a very hard upgrade strategy: I just delete a
    //  possible previous version of the table!
    //  But it somehow doesn't work, maybe I have to add 'await' before the
    //  db.execute(...) ??
//    db.execute('DROP TABLE IF EXISTS $table');
//    print('Old table successfully deleted before HARD upgrade!');
//    _onCreate(db, newVersion);
//    print(
//        "HARD upgrade was successfull! oldVersion: $oldVersion, newVersion: $newVersion");
  }

  // ---------------//
  // Helper methods //
  // ---------------//

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Movie movie) async {
    Database db = await instance.database;
    return await db.insert(table, movie.toMap());

    // TODO: since I don't work with autogenerated id's, I have to check first
    //  whether the object already exists. In that case, an update would make
    //  more sense!
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    Database db = await instance.database;
    return await db.query(table);

    // TODO: maybe try to return a  Future<List<Movie>, by using the named
    //   constructor Movie.fromMap(..) for each movie.
  }

  Future<Movie> getMovie(int id) async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT * FROM $table WHERE $columnId = $id');

    if (result.length > 0) {
      return new Movie.fromMap(result.first);
    }

    return null;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> getCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Movie movie) async {
    Database db = await instance.database;
    return await db.update(table, movie.toMap(),
        where: '$columnId = ?', whereArgs: [movie.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
