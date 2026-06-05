import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'gr_id.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE predictions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT,
            label TEXT,
            confidence REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  // 🔥 INSERT
  static Future<void> insertPrediction(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'predictions',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🔥 GET ALL
  static Future<List<Map<String, dynamic>>> getPredictions() async {
    final db = await database;
    return await db.query('predictions', orderBy: 'id DESC');
  }

  // 🔥 DELETE ALL
  static Future<void> clearHistory() async {
    final db = await database;
    await db.delete('predictions');
  }
}