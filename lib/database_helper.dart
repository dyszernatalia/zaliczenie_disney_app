import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        imageUrl TEXT NOT NULL
      )
    ''');
  }

  Future<void> addFavorite(
      int id,
      String name,
      String imageUrl,
      ) async {
    final db = await instance.database;

    await db.insert(
      'favorites',
      {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      },
      conflictAlgorithm:
      ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>>
  getFavorites() async {
    final db = await instance.database;

    return await db.query('favorites');
  }

  Future<void> deleteFavorite(
      int id,
      ) async {
    final db = await instance.database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}