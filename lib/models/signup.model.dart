class SignupModel{

  // Initialize email
  late String first_name;

  // Initialize email
  late String last_name;

  // Initialize email
  late String email;

  // Initialize email
  late String phone_number;  

  // Initialize email
  late String account_type;  

  // Initialize password
  late String password;

  // Initialize email
  late String password_confirmation;  

  // Initilize constructor
  SignupModel(
    {
      this.first_name             = "", 
      this.last_name              = "",
      this.email                  = "",
      this.phone_number           = "",
      this.account_type           = "",
      this.password               = "",
      this.password_confirmation  = "",
    }
  );

  Map<String,dynamic> toMap () {
    return  {
      "first_name":            first_name,
      "last_name":             last_name,
      "email":                 email,
      "phone_number":          phone_number,
      "account_type":          account_type,
      "password":              password,
      "password_confirmation": password_confirmation
    };
  }
}