import 'package:movie/model/movies_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DatabaseHelper.internal();

  initDB() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "movies.db");
    var theDB = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate
    );
    return theDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Movies(id INTEGER PRIMARY KEY, title TEXT, year TEXT, rating TEXT, description TEXT, poster TEXT)");
  }


  Future<int> saveMovie(Movie movie) async{
    var dbClient = await db;
    int result = await dbClient.insert("Movies", movie.toMap());
    print(result);
    return result;
  }

  Future<List<Movie>> getMovie() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Movies');
    List<Movie> movies = new List();
    for(int i=0; i<list.length; ++i){
      var movie = new Movie(list[i]["title"], list[i]["year"], list[i]["rating"], list[i]["description"], list[i]["poster"]);
      movie.setMovieId(list[i]["id"]);
      movies.add(movie);
    }
    return movies;
  }

  Future<int> deleteMovie(Movie movie) async{
    var dbClient = await db;
    int result = await dbClient.rawDelete("DELETE FROM Movies WHERE id = ?", [movie.id]);
    return result;
  }
}