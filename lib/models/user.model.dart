import 'package:markholdings_ecommerce/database/init.database.dart';
import 'package:markholdings_ecommerce/entities/user.entity.dart';
import 'package:sqflite/sqflite.dart';

class UserModel {
  final tableName = 'user';
  final DatabaseService databaseService = DatabaseService();

  Future<int> create({required String email, required String access_token, required String refresh_token,required String token_type}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (email,access_token,refresh_token,token_type) VALUES (?,?,?,?)''',
      [email,access_token,refresh_token,token_type]
    );
  }

  // Future<dynamic> findOneByEmail(email) async{
  //   final database = await DatabaseService().database;
  //   final find     = await database.rawQuery(
  //     "SELECT * FROM $tableName WHERE email = '$email'"
  //   );
  //   if ( find.isNotEmpty ){
  //     final Map<String,dynamic> user = find[0];
  //     return UserEntity(user['email'], user['access_token'], user['refresh_token']);
  //   }
  //   return Map.from({});
  // }

  Future<dynamic> first() async{
    final database = await DatabaseService().database;
    final find     = await database.rawQuery(
      "SELECT * FROM $tableName"
    );
    if ( find.isNotEmpty ){
      final Map<String,dynamic> user = find[0];
      return UserEntity(user['email'], user['access_token'], user['refresh_token'], user['token_type']);
    }
    return Map.from({});
  }  

}