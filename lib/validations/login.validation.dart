class LoginValidation {
  
  final Map<String, dynamic> auth;
  
  final Map<String, dynamic> user;

  const LoginValidation({
    required this.auth,
    required this.user,
  });

  factory LoginValidation.fromJson(Map<String,dynamic> json) {
    return LoginValidation(
      auth: json['auth'],
      user: json['user'],
    );
  }  

}