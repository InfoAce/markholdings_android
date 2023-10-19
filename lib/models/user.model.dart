import 'package:markholdings_ecommerce/database/init.database.dart';
import 'package:markholdings_ecommerce/entities/user.entity.dart';
import 'package:sqflite/sqflite.dart';

class UserModel {
  final tableName = 'user';

  Future<int> create({required String email, required String token, required int blocked}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (email,token,blocked) VALUES (?,?,?)''',
      [email,token,blocked]
    );
  }

  Future<dynamic> findOneByEmail(email) async{
    final database = await DatabaseService().database;
    final find     = await database.rawQuery(
      "SELECT * FROM $tableName WHERE email = '$email'"
    );
    if ( find.isNotEmpty ){
      final Map<String,dynamic> user = find[0];
      return UserEntity(user['email'], user['token'], user['blocked']);
    }
    return Map.from({});
  }

  Future<dynamic> first() async{
    final database = await DatabaseService().database;
    final find     = await database.rawQuery(
      "SELECT * FROM $tableName"
    );
    if ( find.isNotEmpty ){
      final Map<String,dynamic> user = find[0];
      return UserEntity(user['email'], user['token'], user['blocked']);
    }
    return Map.from({});
  }  

}