import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:markholdings_android/services/api.dart';
import 'package:markholdings_android/views/components/custom_search_bar.dart';
import 'package:markholdings_android/views/validation/products_validation.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key, this.categoryId = ""}) : super(key: key);

  final String categoryId;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  late ApiService api;

  @override
  Widget build(BuildContext context) {
    api = Provider.of<ApiService>(context);
    return SingleChildScrollView(
      child: StickyHeader(
        header: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0),
                child: CustomSearchBar(),
              ),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder<ProductsValidation>(
            future: fetchProducts(),
            builder: (context,snapshot) {
              if( snapshot.hasError){
    
              } else if( snapshot.hasData ){
                  List<dynamic> products = snapshot.data!.products['data'];
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: const ScrollPhysics(),
                    children: products.map( (category) {
                      return InkWell(
                        onTap: (){
                          // DefaultTabController.of(context).animateTo(1);
                          // Navigator.push(
                          //   context, 
                          //   MaterialPageRoute(
                          //     builder: (context) => Home(categoryId: category['id']) )
                          // );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      child: Image.network(
                                        category['image_url'],
                                        height: 110,
                                        fit: BoxFit.fitWidth
                                      ),  
                                    ),                                          
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: DefaultTextStyle(
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Rubik',
                                            color: Colors.blueAccent
                                        ),
                                        child: Text(category['name']),
                                      ),
                                    ),                                    
                                              
                                  ],
                                )
                              )    
                            ),
                          ),
                      );
                    }).toList()
                  );
              }
              return const Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );                  
            }
          )
        ) 
      ),
    );
  }

  Future<ProductsValidation> fetchProducts() async { 
    
    final response = await api.get(Uri.parse('shop'.toString()));

    if( response.statusCode == 200 ){
      // If the server did not return a 200 OK response,
      // then throw an exception.     
      return ProductsValidation.fromJson(jsonDecode(response.body));
    }  else {
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      throw Exception("Something went wrong.");
    }

  }  
}
