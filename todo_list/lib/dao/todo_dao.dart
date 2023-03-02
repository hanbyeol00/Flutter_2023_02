import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/todo_dto.dart';

// DB CRUD 를 실행할 클래스
/*
 * Future<Class>
 * 
 * 함수에서 실제 return 하는 데이터 type 이 Class
 * 이 클래스를 Future 로 감싼 이유
 * 함수를 실행했을때 실제로 내부의 코드가 작동되고
 * 어떤 데이터가 생성되는데
 * 이 함수를 미래에 사용하여 데이터를 얻겠다 라는 선언
 * 
 * State 클래스에서 사용할 데이터를 return 하는 함수는
 * 모든 return type Future<ReturnType> 로 감싸준다
 * 그러면 함수가 실행되면서 return 되는 데이터가
 * State 를 통해서 화면에 그릴수 있도록 한다
 */
class TodoDao {
  late Database _database;

  // _database 변수를 참조하기 위한 getter 함수 선언
  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  final String createTableSQL = '''
    CREATE TABLE todo_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sdate TEXT,
      stime TEXT,
      content TEXT,
      edate TEXT,
      etime TEXT
    )
  ''';

  // table 생성하는 함수
  Future<void> _onCreateTable(db, version) {
    return db.execute(createTableSQL);
  }

  Future<void> _onUpgradeTable(db, oldVersion, newVersion) async {
    if (oldVersion < newVersion) {
      final batch = _database.batch();
      batch.execute("DROP TABLE todo_table");
      batch.execute(createTableSQL);
      await batch.commit();
    }
  }

  Future<Database> initDB() async {
    // 단말기에 설치된 DBMS 저장 경로를 알려달라
    String dbPath = await getDatabasesPath();

    /**
     * 만약 dbPath 가 '/user/db' 라는 경로이다 라고 하면
     * '/user/db/todo.db' 라는 이름의 실제 파일 경로를
     * 만들어달라
     */
    String dbFile = join(dbPath, "todo.db");

    return await openDatabase(
      // dbFile 을 open 해달라
      dbFile,
      onCreate: _onCreateTable,
      onUpgrade: _onUpgradeTable,
      version: 1,
    );
  }

  // DBMS 의 Table 에서 데이터를 Select * 하여
  // List<TodoDto> type 으로 return 해 주는 함수
  Future<List<TodoDto>> selectAll() async {
    final db = await database;
    // todo_table 에서 SELECT 실행하여 todoList 에 담아라
    final List<Map<String, dynamic>> todoList = await db.query("todo_table");

    return List.generate(todoList.length, (index) {
      return TodoDto(
        id: todoList[index]['id'],
        sdate: todoList[index]['sdate'],
        stime: todoList[index]['stime'],
        content: todoList[index]['content'],
        // 만약 todoList[index]['edate'] 값이 null 이 아니면
        // 그 값을 edate 에 보내고
        // 만약 null 이면 "" 을 edate 에 보내라
        edate: todoList[index]['edate'] ?? "",
        etime: todoList[index]['etime'] ?? "",
      );
    });
  } // end select All

  insert(TodoDto todo) async {
    final db = await database;
    await db.insert(
      "todo_table",
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("insert 결과");
  }
}
