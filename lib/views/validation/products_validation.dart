class ProductsValidation {
  
  final Map<String,dynamic> products;

  const ProductsValidation({
    required this.products,
  });

  factory ProductsValidation.fromJson(Map<String,dynamic> json) {
    return ProductsValidation(
      products: json['products'],
    );
  }  

}