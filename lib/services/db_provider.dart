import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:projzespoloey/services/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//String userTable = "user";
String carTable = "cars";
//String insuranceTable = "insurance";
class DbProvider {
  static Database? _database;
  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database?> get database async {
    //if database exists return databse
    if (_database != null) return _database;

    //if db doesn't exists, create
    _database = await initDB();
  }

  //Create db and person table
  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'persons_list.db');

    return await openDatabase(path, onOpen: (db) {},
      onCreate: (Database db, version) async {
      // await db.execute("DROP DATABASE cars");
        await db.execute('CREATE TABLE $carTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, engine TEXT, productionDate TEXT, imageUrl TEXT)');
      }, version: 1,
    );
  }

  //Insert into db
  createUsers(Car newCar) async {
    final db = await database;
    print("baza danych: $db");
    final res = await db?.rawInsert("INSERT INTO cars(name, engine, productionDate, imageUrl) VALUES ('polonez', 'caro', '2022-02-02', 'chuj')");
    print('czy dodano $res');
    return res;
  }

  getData() async{
    final db = await database;
    print("baza danych: $db");
    final res = await db?.rawQuery("SELECT * FROM cars");
    print('czy dodano2 $res');
    return res;
  }

  Future setAutoIncrement() async{
    final db = await database;
    final res = await db?.rawQuery("UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='$carTable'");
    return res;
  }

  //Delete all users
  Future<int?> deleteAllUsers() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM $carTable');
    return res;
  }


  //
  // Future getAllUsers() async {
  //   final db = await database;
  //   // List<Map<String, dynamic>>? maps =  [];
  //   var query = await db?.query(tableName);
  //   if(query != null){
  //     // List Map<String, dynamic> maps = {};
  //     List<dynamic> maps = query;
  //     print('not null ${query.length}');
  //     if(query.length > 0){
  //       print('data with id: $maps');
  //       return maps.map((elem) => Car.fromDatabase(elem)).toList();
  //       // for(int i=0; i<query.length; i++){
  //       //   maps.add(query[i]);
  //       // }
  //       return {"userList": maps};
  //     }
  //     // for(int i=0; i<query)
  //     // return maps.map((row) => Person.fromMap(row)).toList();
  //   }else {
  //     return query;
  //   }
  //}


  // Future<void> updateMobile(Person person, int id) async {
  //   // Get a reference to the database.
  //   final db = await database;
  //
  //   // Update the given record
  //   await db?.update(
  //     '$tableName',
  //     person.toJson(),
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }
}