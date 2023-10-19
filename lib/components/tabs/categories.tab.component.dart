import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/components/builders/categories.builder.dart';
import 'package:markholdings_ecommerce/components/global/searchbar.component.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CategoriesTab extends StatefulWidget {
  
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {

  filterCategories(){

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StickyHeader(
        header: Container(
          child: CustomSearchBar(placeholder: 'Search for a category',callback: filterCategories),
        ),
        content: Container(
          child: const Column(
            children: [
              Align(
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
              CategoriesBuilders()                
            ],
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    // ignore: avoid_print
    super.dispose();
  }
  
}