import 'package:sqflite/sqflite.dart';

class MarkHoldingsDB{
  final userTableName = 'user';

  Future<void> createTables(Database database) async {
    await createUserTable(database);
  }

  Future<void> createUserTable(Database database) async {
    await database.execute(
      "CREATE TABLE IF NOT EXISTS $userTableName (" 
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        " email TEXT,"
        " token TEXT,"
        " blocked BIT,"
        " Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP"    
      ")"
    );
  } 
}