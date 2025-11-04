import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markholdings_9/components/builders/products.builder.dart';
import 'package:markholdings_9/components/global/searchbar.component.dart';
import 'package:markholdings_9/services/api.service.dart';
import 'package:markholdings_9/validations/products.validation.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:redux/redux.dart';
import 'package:provider/provider.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> with SingleTickerProviderStateMixin {

  Map<String,dynamic> products = {};

  late List<dynamic> productList = List.empty();

  bool isLoading = true;

  int currentPage = 1;

  String filter = "";

  fetchMore(){
    if( products['last_page'] != currentPage ){
      setState(() => isLoading = true );          
    }

    if (isLoading && products['last_page'] != currentPage) {
      fetchProducts(page: products['current_page'] + 1,search: filter.isNotEmpty ? filter : "" ).then( (value) {
        setState( 
          () { 
            products = value.products; 
            productList = [...productList, ...value.products['data']]; 
            isLoading = false;
            currentPage = products['current_page'];
          }
        ) ;
      });
    }          
  }

  filterProducts(name) {
    setState( () { 
      isLoading = true;
      products  = {}; 
      filter    = name;
    });
    fetchProducts(page: 1,search: name ).then( (value) {
      setState( () { 
        products    = value.products; 
        productList = ( value.products['data'] as List ).map( (value) {
          value['cart'] = false;
          return value;
        }).toList();
        isLoading   = false;
        currentPage = products['current_page'];
        }
      ) ;
    });    
  }

  @override
  void initState(){
    fetchProducts(page: currentPage).then(
      (value) => setState( (){ 
        products    = value.products; 
        productList = ( value.products['data'] as List ).map( (value) {
          value['cart'] = false;
          return value;
        }).toList();
        isLoading   = false;
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StickyHeader(
        header: Container(
          child: CustomSearchBar(placeholder: 'Search for a product, category, part number',callback: filterProducts ),
        ),
        content: Container(
          child:  Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Rubik',
                        color: Colors.blueAccent
                    ),
                    child: Text("Available products"),
                  ),
                ), 
              ),  
              productList.isEmpty ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading ?
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          )
                        :  const DefaultTextStyle(
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Rubik',
                                color: Colors.blueAccent
                            ),
                            child: Text("No products found."),
                          ),  
                      ]
                    ),
                  ) 
                : ProductsBuilder( products: productList, callback: fetchMore ),
                isLoading && productList.isNotEmpty ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        )
                      ]
                    ),
                  ) 
                : Container(padding: const EdgeInsets.only(top: 5.0),)      
            ],
          )
        )
      ),
    );
  }
  Future<ProductsValidation> fetchProducts({page = 1,search = ""}) async { 
    
    String uri  = 'shop?page=$page';
    final store = Provider.of<Store>(context,listen: false);   

    if( search.isNotEmpty) {
      uri = '$uri&search=$search';
    }
    
    if(store.state.category["id"].isNotEmpty){
      uri = '$uri&category_id=${store.state.category["id"]}';
    }


    final response = await Provider.of<ApiService>(context,listen: false).get(Uri.parse(uri.toString()));

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
