import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/features/todo/data/model/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id       TEXT PRIMARY KEY,
            title    TEXT NOT NULL,
            done     INTEGER NOT NULL,
            priority TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // احذف الجدول القديم واعمل واحد جديد بـ TEXT id
          await db.execute('DROP TABLE IF EXISTS todos');
          await db.execute('''
            CREATE TABLE todos(
              id       TEXT PRIMARY KEY,
              title    TEXT NOT NULL,
              done     INTEGER NOT NULL,
              priority TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await instance.database;
    return await db.query('todos', orderBy: 'rowid DESC');
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await instance.database;
    return await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(String id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}