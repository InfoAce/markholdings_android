import 'package:sqflite/sqflite.dart';

class MarkHoldingsDB{
  final userTableName = 'user';

  Future<void> createTables(Database database) async {
    print('creating');
    await createUserTable(database);
  }

  Future<void> createUserTable(Database database) async {
    print('create_user');
    await database.execute(
      "CREATE TABLE IF NOT EXISTS $userTableName (" 
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        " access_token TEXT,"
        " email TEXT,"
        " token_type TEXT,"
        " refresh_token TEXT,"
        " Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP"    
      ")"
    );
  } 
}