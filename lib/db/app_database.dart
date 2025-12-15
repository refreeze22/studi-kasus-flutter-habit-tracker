import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:studi_kasus_flutter_habit_tracker/models/habit.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE habits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      scheduleTime TEXT NOT NULL,
      isCompleted INTEGER NOT NULL,
      createdAt TEXT NOT NULL
    )
    ''');
  }

  Future<Habit> insertHabit(Habit habit) async {
    final db = await instance.database;
    final id = await db.insert('habits', habit.toMap());
    return habit..id = id;
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await instance.database;
    final maps = await db.query('habits');

    if (maps.isNotEmpty) {
      return maps.map((json) => Habit.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
