import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/validations/categories.validation.dart';
import 'package:provider/provider.dart';

class CategoriesBuilders extends StatefulWidget {
  const CategoriesBuilders({super.key});

  @override
  State<CategoriesBuilders> createState() => _CategoriesBuildersState();
}

class _CategoriesBuildersState extends State<CategoriesBuilders> {

  late ApiService api;
  
  @override
  Widget build(BuildContext context) {
    api = Provider.of<ApiService>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: FutureBuilder<CategoriesValidation>(
          future: fetchCategories(),
          builder: (context, snapshot) {
            if( snapshot.hasError ){
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              List<dynamic> categories = snapshot.data!.categories;
              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: categories.map( (category) {
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
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
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
                                DefaultTextStyle(
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Rubik',
                                      color: Colors.black54
                                  ),
                                  child: Text(category['description']),
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
            return Container(
              height: (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.25 ) ),
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
            );        
          },
        ),
    );
  }

  Future<CategoriesValidation> fetchCategories() async { 
    
    final response = await api.get(Uri.parse('categories'.toString()));

    if( response.statusCode == 200 ){
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      return CategoriesValidation.fromJson(jsonDecode(response.body));
    }  else {
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      throw Exception("Something went wrong.");
    }

  }  
}