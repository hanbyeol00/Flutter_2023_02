import 'package:flutter_talkwise/modules/category_dto.dart';
import 'package:flutter_talkwise/modules/qa_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TalkWiseDBService {
  late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  onCreateTable(db, version) async {
    await db.execute('''
      CREATE TABLE tbl_QA(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        answer TEXT,
      )
    ''');
    await db.execute('''
      CREATE TABLE tbl_category(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category VARCHAR(256) NOT NULL,
        qa_id INTEGER,
        FOREIGN KEY (qa_id) REFERENCES tbl_QA(id)
      )
    ''');
  }

  Future<Database> initDB() async {
    String dbPath = await getDatabasesPath();

    String dbFile = join(dbPath, "talkwise_database.db");

    return await openDatabase(
      dbFile,
      onCreate: onCreateTable,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS tbl_QA");
        await db.execute("DROP TABLE IF EXISTS tbl_category");
        await onCreateTable(db, newVersion);
      },
      version: 1,
    );
  }

  Future<void> qaInsert(QA qa) async {
    final db = await database;

    await db.insert(
      "tbl_QA",
      qa.qaMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> categoryInsert(Category category) async {
    final db = await database;

    await db.insert(
      "tbl_category",
      category.categoryMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QA>> qaSelectAll() async {
    final db = await database;

    final List<Map<String, dynamic>> qaMaps = await db.query("tbl_QA");
    return List.generate(
      qaMaps.length,
      (index) {
        return QA(
          id: qaMaps[index]['id'],
          question: qaMaps[index]['question'],
          answer: qaMaps[index]['answer'],
        );
      },
    );
  }

  Future<int> qaDelete(int id) async {
    final db = await database;
    return db.rawDelete(
      "DELETE FROM tbl_QA WHERE id = ?",
      [id],
    );
  }

  Future<List<Category>> getCategoryList() async {
    final db = await database;

    final List<Map<String, dynamic>> categoryMaps =
        await db.query("tbl_category");

    return List.generate(
      categoryMaps.length,
      (index) {
        return Category(
          id: categoryMaps[index]['id'],
          qa_id: categoryMaps[index]['qa_id'],
          category: categoryMaps[index]['category'],
        );
      },
    );
  }

  Future<List<Category>> selectCategory(String category) async {
    final db = await database;

    final List<Map<String, dynamic>> res = await db.query(
      'tbl_category',
      where: 'category = ?',
      whereArgs: [category],
    );

    print("object");
    print(res);
    return List.generate(
      res.length,
      (index) {
        return Category(
          id: res[index]['id'],
          qa_id: res[index]['qa_id'],
          category: res[index]['category'],
        );
      },
    );
  }
}
