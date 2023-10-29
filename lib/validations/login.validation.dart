class LoginValidation {
  
  final String access_token;
  
  final String refresh_token;

  final String token_type;

  const LoginValidation({
    required this.access_token,
    required this.refresh_token,
    required this.token_type,
  });

  factory LoginValidation.fromJson(Map<String,dynamic> json) {
    return LoginValidation(
      access_token:  json['access_token'],
      refresh_token: json['refresh_token'],
      token_type:    json['token_type'],
    );
  }  

}