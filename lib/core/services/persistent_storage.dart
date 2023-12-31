import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entities/records.dart';

class PersistentStorage {
  
  Database? _database;
  String tableName = 'record';

  // PersistentStorage._() {
  //   _initDatabase();
  //   _onCreateFunc(_database!, 1);
  // }
   
  // static final PersistentStorage shared = PersistentStorage._();

  PersistentStorage() {
    _initDatabase();
  }

  Future<Database> get database async 
  {
    if (_database != null) {
     return _database!;
    }

    _database = await _initDatabase();
    return _database!;
    
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateFunc,
    );
  }

  Future<void> _onCreateFunc(Database db, int version) async {
    var checkExist = await db.rawQuery("SELECT * FROM sqlite_master WHERE name ='$tableName' and type='table'");

    if(checkExist.isEmpty) {
      await db.execute('''

      CREATE TABLE record (
        id VARCHAR PRIMARY KEY,
        uLatitude DOUBLE,
        uLongitude DOUBLE, 
        uPlaceId VARCHAR,
        dLatitude DOUBLE,
        dLongitude DOUBLE,
        dPlaceId VARCHAR,
        description VARCHAR,
        date VARCHAR,
        completed INT,
        title VARCHAR
      )

    ''');
    }
  }

  Future<void> insertRow(Database db, CustRecord rec) async {
    await db.insert('record', rec.toMap());
  }

  Future<List<Map>> getRow(Database db) async {
    return await db.query(
      "record", 
      columns: [
        'id',
        'uLatitude',
        'uLongitude',
        'uPlaceId',
        'dLatitude',
        'dLongitude',
        'dPlaceId',
        'description',
        'date',
        'completed',
        'title',

      ]);
  }
}