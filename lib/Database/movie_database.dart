import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_movie/Database/database_model.dart';


class MovieDatabase{
  static final MovieDatabase instance = MovieDatabase.init();

  static Database? _database;

  MovieDatabase.init();

  Future<Database> get database async{
    if (_database != null) return _database!;

    _database = await _initDB('karyawan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableMovie (
    ${MovieFields.id} $idType,
    ${MovieFields.name} $textType,
    ${MovieFields.imagePath} $textType,
    ${MovieFields.idMovie} $textType
    
    
    )''');
  }

  Future<MovieModel> create(MovieModel news) async{
    final db = await instance.database;

    final id = await db.insert(tableMovie, news.toJson());
    return news.copy(id: id);
  }

  Future<MovieModel> read(int? id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableMovie,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty){
      return MovieModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MovieModel>> readAll() async{
    final db = await instance.database;

    final result = await db.query(tableMovie);

    return result.map((json) => MovieModel.fromJson(json)).toList();
  }

  delete(int? id) async {
    final db = await instance.database;
    try {
      await db.delete(
        tableMovie,
        where: '${MovieFields.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }

  update(MovieModel karyawanModel) async {
    final db = await instance.database;
    try {
      db.rawUpdate('''
    UPDATE ${tableMovie} 
    SET ${MovieFields.name} = ?, ${MovieFields.idMovie} = ?, ${MovieFields.imagePath} = ?
    WHERE ${MovieFields.id} = ?
    ''', [
        karyawanModel.name,
        karyawanModel.idMovie,
        karyawanModel.imagePath,
        karyawanModel.id
      ]);
    } catch (e) {
      print('error: ' + e.toString());
    }
  }


  Future close() async{
    final db = await instance.database;
    db.close();
  }
}