import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app/components/builders/categories.builder.dart';
import 'package:android_app/components/global/searchbar.component.dart';
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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blueAccent
          ),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children:[
                      Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: const Icon(
                        Icons.list,
                        color: Colors.white,
                      ),                       
                    ),
                    Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05
                      )
                    ),                       
                  ]
                ),                                    
              ]
            ),
          )  ,
        ),
        content: Container(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0,top: 5.0),
                  child:Text(
                    'List of categories',
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontSize: MediaQuery.of(context).size.width * 0.04
                    )
                )  
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