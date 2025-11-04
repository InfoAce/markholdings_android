import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markholdings/components/builders/categories.builder.dart';
import 'package:markholdings/store/actions/category.action.store.dart';
import 'package:markholdings/components/global/searchbar.component.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:redux/redux.dart';
import 'package:provider/provider.dart';
import 'package:markholdings/store/actions/product.action.store.dart';

class CategoriesTab extends StatefulWidget {
  
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  Store? store;

  @override
  void initState() {
    // ignore: avoid_print
    super.initState();

    store        = Provider.of<Store>(super.context,listen:false);

    _resetViewProduct();
  }

  void _resetViewProduct() {
    store?.dispatch(ViewProduct({}));
    store?.dispatch(UpdateCategory({ "id": "", "name": "" })); 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StickyHeader(
        header: Container(
          width: MediaQuery.of(context).size.width,
          decoration:const BoxDecoration(
            color: Colors.blueAccent
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
              const CategoriesBuilders()                
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