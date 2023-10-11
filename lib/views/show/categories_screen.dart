import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:markholdings_android/views/components/custom_search_bar.dart';
import 'package:markholdings_android/views/show/shop_screen.dart';
import 'package:markholdings_android/views/validation/categories_validation.dart';
import 'package:markholdings_android/services/api.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  late ApiService api;

  @override
  Widget build(BuildContext context) {
    api = Provider.of<ApiService>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        verticalDirection: VerticalDirection.down,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0 )
          ),
          const CustomSearchBar(),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0,top: 5.0),
              child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Rubik',
                    color: Colors.blueAccent
                ),
                child: Text("Categories"),
              ),
            ), 
          ),
          Padding(
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
                  return const Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );        
                },
              ),
          ),
        ]
      ),
    );
  }

  @override
  void dispose() {
    // ignore: avoid_print
    super.dispose();
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