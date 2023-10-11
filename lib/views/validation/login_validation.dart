class LoginValidation {
  
  final Map<String,dynamic> token;

  const LoginValidation({
    required this.token,
  });

  factory LoginValidation.fromJson(Map<String,dynamic> json) {
    return LoginValidation(
      token: json['token'],
    );
  }  

}