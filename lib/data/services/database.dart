import 'package:home_service/data/models/user_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user_data.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        email TEXT,
        address TEXT,
        role TEXT,
        photo TEXT,
        token TEXT
      )
    ''');
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('user', {
      'id': user.id,
      'email': user.email,
      'address': user.address,
      'role': user.role,
      'photo': user.photo ?? '',
      'token': user.token ?? '',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserModel>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(maps.length, (i) {
      return UserModel(
        id: maps[i]['id'],
        username: maps[i]['username'] ?? '', // Assuming username is optional
        phone: maps[i]['phone'] ?? '', // Assuming phone is optional
        email: maps[i]['email'],
        address: maps[i]['address'],
        role: maps[i]['role'],
        photo: maps[i]['photo'],
        token: maps[i]['token'],
      );
    });
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }
}
