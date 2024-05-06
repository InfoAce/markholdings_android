class CategoriesValidation {
  
  final dynamic categories;

  const CategoriesValidation({
    required this.categories,
  });

  factory CategoriesValidation.fromJson(dynamic json) {
    return CategoriesValidation(
      categories: json['categories'],
    );
  }  

}