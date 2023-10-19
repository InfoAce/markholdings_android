import 'dart:ffi';

class UserEntity{

  // Initialize email
  final String _email;

  // Initialize token
  final String _token;

  // Initialize blocked
  final Int _blocked;

  UserEntity(this._email,this._token,this._blocked);

  // Fetch blocked
  Int get blocked => _blocked;

  // Fetch email
  String get email => _email;

  // Fetch token
  String get token => _token;    

}