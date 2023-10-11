class SplashScreenValidation {
 
  final dynamic company; 

  const SplashScreenValidation({
    required this.company,
  });

  factory SplashScreenValidation.fromJson(Map<String, dynamic> json) {
    return SplashScreenValidation(
      company: json['company'],
    );
  }
  
}