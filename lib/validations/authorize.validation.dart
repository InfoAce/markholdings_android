class AuthorizationValidation {
  
  final Map<String,dynamic> device;

  final Map<String,dynamic> user;

  const AuthorizationValidation({
    required this.device,
    required this.user,
  });

  factory AuthorizationValidation.fromJson(Map<String,dynamic> json) {
    return AuthorizationValidation(
      device: { 
        "id":json['device']['d_id'],
        "name":json['device']['d_name'],
        "blocked":json['device']['blocked']
      },
      user: json['device']['user'],
    );
  }  

}