import 'dart:async';

import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app/store/actions/product.action.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class ProductBase extends StatefulWidget {
  ProductBase({super.key,required this.product});

  late Map<String,dynamic> product;
  int minQuantity = 1;

  @override
  State<ProductBase> createState() => _ProductBaseState();
}

class _ProductBaseState extends State<ProductBase> {
  late String category;
  late int productCategoriesCount;
  late List<dynamic> cart;

  ValueNotifier<bool> _inCart = ValueNotifier<bool>(false);
  ValueNotifier<num> quantity = ValueNotifier<num>(1);
  ValueNotifier<num> total    = ValueNotifier<num>(0);

  @override
  void initState(){
    fetchCart();
    category = widget.product['product_category']['name'];
    // productCategoriesCount = widget.category['product_categories_count'];
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height:  MediaQuery.of(context).size.height * 0.2,
      width:   MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          image: DecorationImage(
            image: Image.network(widget.product['image_url']).image,
            fit: BoxFit.cover,
          ),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.6),
          ),  
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                  widget.product['product_category']['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.05
                  )
                ),
                Text(
                  widget.product['name'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04
                  )
                )                                                                                
              ]
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _inCart, 
                  builder: (BuildContext context, bool value, Widget? child) { 
                    return IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: value == false ? Colors.white : Colors.grey,
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                      iconSize: MediaQuery.of(context).size.width * 0.07,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if( value == true ){ 
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.blueAccent,
                            content: Row(
                              children: [
                                Icon(
                                  color: Colors.white,
                                  Icons.info
                                ),
                                Flexible(child: Text('This product is already in the cart.'))
                              ],
                            ),
                          ));     
                        }

                        if( value == false ){
                          showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child:  Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Add to cart",
                                              style: GoogleFonts.poppins(
                                                color: Colors.blueAccent,
                                                fontSize: MediaQuery.of(context).size.width * 0.06
                                              )
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Timer.periodic(const Duration(seconds: 1), (timer) {
                                                  timer.cancel();
                                                  quantity.value = 1;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.close)
                                            )
                                          ]
                                        ),
                                      ),
                                      Container(
                                        height:  MediaQuery.of(context).size.height * 0.2,
                                        width:   MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.4),
                                                Colors.black.withOpacity(0.4),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            image: DecorationImage(
                                              image: Image.network(widget.product['image_url']).image,
                                              fit: BoxFit.cover,
                                            ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              color: Colors.black.withOpacity(0.6),
                                            ),  
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                widget.product['name'],
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width * 0.05
                                                )
                                              ),
                                            ), 
                                            ValueListenableBuilder<num>(
                                              valueListenable: total, 
                                              builder: (BuildContext context, num value, Widget? child) {
                                                final currency = widget.product["currency"];
                                                return Container(
                                                  alignment: Alignment.topRight,
                                                  padding: EdgeInsets.all(15.0),
                                                  child:  Text(
                                                    "$currency $value",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                );                              
                                                // return Text(
                                                //   '$count',
                                                //   textAlign: TextAlign.center,
                                                //   style: const TextStyle(
                                                //     color: Colors.black87,
                                                //     fontSize: 18.0,
                                                //     fontWeight: FontWeight.w500,
                                                //   ),
                                                // );
                                              }, 
                                            ),                                                                                                                                                                                                        
                                          ]
                                        )
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove,
                                                color: Colors.blueAccent,
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                                              iconSize: 32.0,
                                              color: Theme.of(context).primaryColor,
                                              onPressed: () {
                                                setState(() {
                                                  num price   = widget.product['price'];
                                                  if (quantity.value > widget.minQuantity) {
                                                    quantity.value --;
                                                    total.value = (quantity.value * price);
                                                  }
                                                });
                                              },
                                            ),
                                            ValueListenableBuilder<num>(
                                              valueListenable: quantity, 
                                              builder: (BuildContext context, num value, Widget? child) {
                                                // This builder will only get called when the _counter
                                                // is updated.
                                                final count = quantity.value;
                                                return Text(
                                                  '$count',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                );
                                              }, 
                                            ),                            
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.blueAccent,
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                                              iconSize: 32.0,
                                              color: Theme.of(context).primaryColor,
                                              onPressed: () {
                                                num price   = widget.product['price'];
                                                setState(() {
                                                  quantity.value ++;
                                                  total.value = (quantity.value * price);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),                        
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            child: const Text('Add'),
                                            onPressed: () {
                                              addProduct({
                                                'id':          widget.product['id'],
                                                'price':       widget.product['price'],
                                                'total':       total.value,
                                                'quantity':    quantity.value,
                                                'minQuantity': widget.minQuantity
                                              });

                                              Timer.periodic(const Duration(seconds: 1), (timer) {
                                                timer.cancel();
                                                quantity.value = 1;
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });     
                        }               
                      },
                    ); 
                  }
                ),                         
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                  iconSize: MediaQuery.of(context).size.width * 0.07,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    final store   = Provider.of<Store>(context,listen: false);   
                    store.dispatch(ViewProduct(widget.product));                    
                  },
                ),                                            
              ],
            ),
          ),                
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(10.0),
            child:Text(
              widget.product['currencyPrice'],
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),                                                                                                                                                                                                                                                                         
        ]
      )
    );
  }
  
  Future<void> addProduct(Map<String,dynamic> data) async{
    
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final shoppingCart = await cacheManager.get('shopping_cart');
    dynamic cart       = [];

    if( shoppingCart != null ){
      cart = shoppingCart.value;
      cart.add(data);
      await cacheManager.remove('shopping_cart');
      await cacheManager.add('shopping_cart',cart);  
    } else {
      cart.add(data);
      await cacheManager.add('shopping_cart',cart);
    }

    if( _inCart.value == false ){
      _inCart.value = true;
    }

  }

  Future<void> fetchCart() async{
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final shoppingCart = await cacheManager.get('shopping_cart');

    ( shoppingCart?.value as List ).forEach( (product){
      if( product['id'] == widget.product['id'] ){
        _inCart.value = true;
      }
    });

  }  
}