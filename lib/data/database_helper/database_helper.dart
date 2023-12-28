import 'package:popular_user_github/models/profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:popular_user_github/models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        _createFavoritesTable(db);
        _createProfileTable(db);
      },
    );
  }

  void _createFavoritesTable(Database db) {
    db.execute(
      '''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        login TEXT,
        avatarUrl TEXT,
        name TEXT,
        email TEXT,
        location TEXT,
        company TEXT
      )
      ''',
    );
  }

  void _createProfileTable(Database db) {
    db.execute(
      '''
      CREATE TABLE profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        position TEXT,
        imageName TEXT
      )
      ''',
    );
  }

  Future<void> insertFavorite(User user) async {
    final db = await database;
    await db.insert('favorites', user.toMap());
  }

  Future<List<User>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<void> removeFavorite(String login) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'login = ?',
      whereArgs: [login],
    );
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await database;
    await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Profile?> getProfile() async {
    final db = await database;
    final result = await db.query('profile');

    if (result.isNotEmpty) {
      return Profile.fromMap(result.first);
    } else {
      return null;
    }
  }
}
