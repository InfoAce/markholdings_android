import 'dart:async'; 
import 'dart:io'; 
import 'package:path/path.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:sqflite/sqflite.dart';  

class SQLiteDbProvider {

    SQLiteDbProvider._(); 

    static final SQLiteDbProvider db = SQLiteDbProvider._(); 

    static Database? _database; 

    Future<Database> get database async {

      if (_database! == null) {
        _database = await initDB(); 
      } 

      return _database!; 
    } 
   
    initDB() async {
      
      Directory documentsDirectory = await getApplicationDocumentsDirectory(); 

      String path = join(documentsDirectory.path, "markholdings.db"); 
      
      return await openDatabase(
          path, 
          version:  1, 
          onOpen:   (db) {}, 
          onCreate: (Database db, int version) async {
            await db.execute(
              "CREATE TABLE IF NOT EXISTS user (" 
                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                " access_token TEXT,"
                " email TEXT,"
                " token_type TEXT,"
                " refresh_token TEXT,"
                " Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP"    
              ")"
            );  
          }
      ); 
      
    }
   
}