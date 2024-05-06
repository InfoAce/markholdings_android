import 'dart:convert';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:android_app/components/builders/base/product.base.builder.dart';
import 'package:android_app/validations/products.validation.dart';
import 'package:provider/provider.dart';

class ProductsBuilder extends StatefulWidget {
  ProductsBuilder({
    super.key,
    required this.products,
    required this.callback
  });

  List<dynamic> products;
  final Function callback;

  @override
  State<ProductsBuilder> createState() => _ProductsBuilderState();
}

class _ProductsBuilderState extends State<ProductsBuilder> {
  
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(_scrollListener);     
    super.initState();
  }

  _scrollListener () {
    if (
      _scrollController.offset >= _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange
      ) {
        widget.callback();   
    }
  }

  @override
  Widget build(BuildContext context) {   
    return Container(
      height:  MediaQuery.of(context).size.height * 0.85,
      width:   MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
      child:   ListView(
        shrinkWrap: true,
        controller: _scrollController,
        children: widget.products.map<Widget>( (product) {
          return ProductBase(product: product);
        }).toList()
      )
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
 

}