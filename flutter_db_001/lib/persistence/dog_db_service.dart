import 'package:flutter_db_001/modules/dog_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DogDBService {
  // late : 변수의 지원 생성 키워드
  // 변수를 즉시 초기화 하지 않고, 잠시 후에 초기화 하겠다
  late Database _database;

  final List<Dog> dogs = [
    const Dog(name: "달이", age: 9),
    const Dog(name: "벼리", age: 4),
    const Dog(name: "초코", age: 6),
    const Dog(name: "콩이", age: 7),
  ];

  /*
   * Future 클래스
   * 현재는 데이터가 없지만,
   * 미래에 데이터가 필요할때 가져다 달라는 용도로 사용하는 클래스
   */
  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  onCreateTable(db, version) {
    return db.execute('''
        CREATE TABLE dogs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age INTEGER
        )
      ''');
  }

  /*
   * DB 에 연결하기 위한 함수
   */
  Future<Database> initDB() async {
    // 디바이스 마다 DB 가 저장된 위치가 다른데
    // 각 디바이스의 DB 가 저장된 경로를 알려주는 함수
    String dbPath = await getDatabasesPath();

    // device/db/dog_database.db 라는 경로를 생성하는 함수(join)
    String dbFile = join(dbPath, "dog_database.db");

    return await openDatabase(
      dbFile,
      onCreate: onCreateTable,
      onUpgrade: (db, oldVersion, newVersion) => db.execute("DELETE FROM dogs"),
      version: 2,
    );
  }

  Future<void> insert(Dog dog) async {
    // insert 하기 위한 database open
    final db = await database;

    await db.insert(
      "dogs",
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> selectAll() async {
    final db = await database;

    final List<Map<String, dynamic>> dogMaps = await db.query("dogs");

    return List.generate(dogMaps.length, (index) {
      return Dog(
        id: dogMaps[index]['id'],
        name: dogMaps[index]['name'],
        age: dogMaps[index]['age'],
      );
    });
  }

  Future<int> delete(int id) async {
    final db = await database;

    return db.rawDelete("DELETE FROM dogs WHERE id = ?", [id]);
    // 아래와 같은 코드 절대 사용금지, DB Injection 곡격노출
    // db.rawDelete("DELETE FROM dogs WHERE id = $[id]");
  }
}
