class ProductsValidation {
  
  final dynamic products;

  const ProductsValidation({
    required this.products,
  });

  factory ProductsValidation.fromJson(dynamic json) {
    return ProductsValidation(
      products: json['products'],
    );
  }  

}