import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// DB SQLite simple para Incident.
// Nota: guardamos enums como texto (name) y la fecha en ISO8601.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'fixit.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final basePath = await getDatabasesPath();
    final fullPath = p.join(basePath, _dbName);

    _db = await openDatabase(
      fullPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE incidents (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            photo_path TEXT NOT NULL,
            category TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Futuras migraciones aquí.
      },
    );
    return _db!;
  }
}
