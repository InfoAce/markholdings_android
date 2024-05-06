import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:android_app/components/builders/base/category.base.builders.dart';
import 'package:android_app/services/api.service.dart';
import 'package:android_app/validations/categories.validation.dart';
import 'package:provider/provider.dart';

class CategoriesBuilders extends StatefulWidget {
  const CategoriesBuilders({super.key});

  @override
  State<CategoriesBuilders> createState() => _CategoriesBuildersState();
}

class _CategoriesBuildersState extends State<CategoriesBuilders> {
  late dynamic categories;
  late List categoryList = List.empty();
  late ScrollController _scrollController;
  int currentPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(_scrollListener);     

    fetchCategories(1).then(
      (value) => setState( (){ 
        categories    = value.categories; 
        categoryList  = value.categories['data'];
        isLoading     = false;
      }
    ));
    super.initState();
  }

  _scrollListener () {
    if (
      _scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange
      ) {
        if( categories['last_page'] != currentPage ){
          setState(() => isLoading = true );          
        }

        if (isLoading && categories['last_page'] != currentPage) {
          fetchCategories((categories['current_page'] + 1)).then(
            (value) => setState( () { 
              categories = value.categories; 
              categoryList = [...categoryList, ...value.categories['data']]; 
              isLoading = false;
              currentPage = categories['current_page'];
              }
            ) 
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  MediaQuery.of(context).size.height * 0.82,
      width:   MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
      child: ListView(
        controller: _scrollController,
        children: categoryList.map( (category) {
          return CategoryBase(category: category);
        }).toList()
      )
    );
  }

  Future<CategoriesValidation> fetchCategories(page) async { 
    
    final response = await Provider.of<ApiService>(context,listen: false).get(Uri.parse('categories?page=$page'.toString()));

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