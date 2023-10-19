import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/components/builders/products.builder.dart';
import 'package:markholdings_ecommerce/components/global/searchbar.component.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({Key? key, this.categoryId = ""}) : super(key: key);

  final String categoryId;

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StickyHeader(
        header: Container(
          child: CustomSearchBar(),
        ),
        content: Container(
          child: const Column(
            children: [
              Align(
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
              ProductsBuilder()                
            ],
          )
        )
      ),
    );
  }

 
}
