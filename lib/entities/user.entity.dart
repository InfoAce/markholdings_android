class UserEntity{

  // Initialize email
  final String _email;

  // Initialize access token
  final String _access_token;

  // Initialize refresh token
  final String _refresh_token;

  // Initialize token type
  final String _token_type;  

  UserEntity(this._email,this._access_token,this._refresh_token,this._token_type);

  // Fetch refrsh token
  String get refresh_token => _refresh_token;

  // Fetch email
  String get email => _email;

  // Fetch access token
  String get access_token => _access_token;
  
  // Fetch token type
  String get token_type => _token_type;      

}