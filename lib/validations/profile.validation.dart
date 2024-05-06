class ProfileValidation {
  
  final Map<String,dynamic> user;

  const ProfileValidation({
    required this.user,
  });

  factory ProfileValidation.fromJson(Map<String,dynamic> json) {
    return ProfileValidation(
      user: json['user'],
    );
  }  

}