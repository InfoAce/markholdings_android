class CompanyValidation {
 
  final dynamic company; 

  const CompanyValidation({
    required this.company,
  });

  factory CompanyValidation.fromJson(Map<String, dynamic> json) {
    return CompanyValidation(
      company: json['company'],
    );
  }
  
}