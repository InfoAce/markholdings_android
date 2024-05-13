class LoginModel{

  // Initialize email
  late String email;

  // Initialize password
  late String password;

    // Initialize password
  late String client_id;

    // Initialize password
  late String client_secret;

  // Initilize constructor
  LoginModel({this.email = "",this.password = "",this.client_id = "",this.client_secret = ""});

  
  Map<String,dynamic> toMap () {
    return  {
      "email":          email,
      "password":       password,
      "client_id":      client_id,
      "client_secret":  client_secret,
    };
  }

}