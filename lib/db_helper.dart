import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'recipe.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // incremented because we added a new table
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table for favorite recipes
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imagePath TEXT,
        ingredients TEXT,
        steps TEXT
      )
    ''');

    // Table for user-created recipes
    await db.execute('''
      CREATE TABLE user_recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        imagePath TEXT,
        ingredients TEXT,
        steps TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // add new columns or tables if needed
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE recipes ADD COLUMN imagePath TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_recipes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          imagePath TEXT,
          ingredients TEXT,
          steps TEXT
        )
      ''');
    }
  }

  // ---------------- FAVORITE RECIPES ----------------

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await instance.database;

    final existing = await db.query(
      'recipes',
      where: 'title = ?',
      whereArgs: [recipe.title],
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int; // already exists
    }

    return await db.insert('recipes', recipe.toMap());
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await instance.database;
    final result = await db.query('recipes');
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> deleteRecipe(int id) async {
    final db = await instance.database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteByTitle(String title) async {
    final db = await instance.database;
    return await db.delete('recipes', where: 'title = ?', whereArgs: [title]);
  }

  // ---------------- USER-CREATED RECIPES ----------------

  Future<int> insertUserRecipe(Recipe recipe) async {
    final db = await instance.database;
    return await db.insert('user_recipes', recipe.toMap());
  }

  Future<List<Recipe>> getUserRecipes() async {
    final db = await instance.database;
    final result = await db.query('user_recipes');
    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> deleteUserRecipe(int id) async {
    final db = await instance.database;
    return await db.delete('user_recipes', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- CLOSE DB ----------------

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
