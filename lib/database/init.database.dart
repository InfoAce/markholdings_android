import 'package:markholdings_ecommerce/database/marholdings.database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> ? _database;

  DatabaseService(){
    print('init Db');
    print(_database);
    if( _database == null ){
      init();
    }
  }

  Future<void> init() async{
    final path = await fullPath;
    // _database = await openDatabase(
    //   path,
    //   version: 1,
    //   onCreate: create,
    //   singleInstance: true
    // );
    _database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "markholdings.db"),
    // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async{
        await MarkHoldingsDB().createTables(db);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,      
    );    
  }  

  Future<dynamic> get database async { 
    return await _database;
  }

  Future<String> get fullPath async {
    const name = "markholdings.db";
    final path = await getDatabasesPath();
    return join(path,name);
  }

  // Future<dynamic> checkTable(table) async {
  //   await _database.rawQuery(
  //     "SELECT name FROM sqlite_master WHERE type='table' AND name='$table'"
  //   );
  // }

  Future<void> create(Database database, int version) async => await MarkHoldingsDB().createTables(database);

}