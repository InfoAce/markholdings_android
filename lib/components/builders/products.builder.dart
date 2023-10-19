import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:loadmore/loadmore.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/validations/products.validation.dart';
import 'package:provider/provider.dart';

class ProductsBuilder extends StatefulWidget {
  const ProductsBuilder({super.key});

  @override
  State<ProductsBuilder> createState() => _ProductsBuilderState();
}

class _ProductsBuilderState extends State<ProductsBuilder> {
  
  late dynamic products;
  late List productList = List.empty();
  late ScrollController _scrollController;
  int currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(_scrollListener);     

    fetchProducts(1).then(
      (value) => setState( (){ 
        products    = value.products; 
        productList = value.products['data'];
        isLoading   = false;
      }
    ));
    super.initState();
  }

  _scrollListener () {
    if (
      _scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange
      ) {
        setState(() {
          isLoading = true;        
        });

        if (isLoading && products['last_page'] != currentPage) {
          fetchProducts((products['current_page'] + 1)).then(
            (value) => setState( () { 
              products = value.products; 
              productList = [...productList, ...value.products['data']]; 
              isLoading = false;
              currentPage = products['current_page'];
              }
            ) 
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {   
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
      child: ListView(
        controller: _scrollController,
        children: [
          productList.isNotEmpty ? 
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              physics: const ScrollPhysics(),
              children: productList.map( (product) {
                return Container(
                  margin: EdgeInsets.all(2.0),
                  // padding: EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: (){
                      // DefaultTabController.of(context).animateTo(1);
                      // Navigator.push(
                      //   context, 
                      //   MaterialPageRoute(
                      //     builder: (context) => Home(categoryId: category['id']) )
                      // );
                    },
                    child: TransparentImageCard(
                      // contentPadding: const EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      imageProvider: Image.network(product['image_url']).image,
                      tags: [
                        Padding(
                          padding: EdgeInsets.only(right: 2.0),
                          child: DefaultTextStyle(
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              color: Colors.black
                            ),
                            child: Badge(
                              label: Text(product['part_number']),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:5.0),
                          child: DefaultTextStyle(
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              color: Colors.white
                            ),
                            child: Badge(
                              label: Text(product['system_code']),
                              backgroundColor: Colors.green,
                            ),
                          ),
                        )                         
                      ],
                      // tags: Row(
                      //   children: product['tag'] != null ? 
                      //   [
                      //       DefaultTextStyle(
                      //         textAlign: TextAlign.start,
                      //         style: const TextStyle(
                      //           fontSize: 12,
                      //           fontFamily: 'Rubik',
                      //           color: Colors.white
                      //         ),
                      //         child: Badge(
                      //           label: Text(product['tag']['name']),
                      //           backgroundColor: Colors.blueAccent,
                      //         ),
                      //       ),
                                                                        
                      //     ]
                      // : List.empty()
                      // ),
                      title: DefaultTextStyle(
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Rubik',
                          color: Colors.white
                        ),
                        child: Text(product['name']),
                      ),
                      description: Row(
                        children: [
                       
                        ],
                      ),
                      // description: Text(product['summary']),
                    ),
                  ),
                );
              }).toList()
            ) 
          : Container(
              height: MediaQuery.of(context).size.height - ( MediaQuery.of(context).size.height * 0.25),
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
          ),
          isLoading && productList.isNotEmpty ? 
            Container(
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
          : const Padding(padding: EdgeInsets.all(5.0))
        ]
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<ProductsValidation> fetchProducts(page) async { 
    
    final response = await Provider.of<ApiService>(context,listen: false).get(Uri.parse('shop?page=$page'.toString()));

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