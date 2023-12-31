import 'dart:convert';

import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markholdings_ecommerce/components/views/checkout.view.component.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/store/actions/tab.action.store.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:redux/redux.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {

  List<dynamic> shoppingCart = [];
  
  @override
  void initState(){
    fetchShoppingCart();
  }

  Future<void> popup() async{
    final store = Provider.of<Store>(context,listen: false);
    final user  = store.state.user;

    if( user.isNotEmpty ){
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CheckoutView(items: shoppingCart),
        );
      });
    } else {
      store.dispatch(UpdateTab(3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),                       
                      ),
                      Text(
                        'Shopping cart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.05
                        )
                      ),                       
                    ]
                  ),              
                  TextButton(
                    onPressed: (){
                      popup();
                      // setState(() {
                      //   num price  = widget.product['price'];
                      //   total.value = (quantity.value * price);
                      // });

                    }, 
                    style:  ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.white, // your color here
                                width: 1,
                              ),
                          ),
                      )
                    ),             
                    isSemanticButton: true,
                    child: Container(
                      child: Text(
                          "Buy now",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.03
                          )
                      ),
                    )
                  )                       
                ]
              ),
            )  ,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10.0),
            child: shoppingCart.isNotEmpty ? 
              Column(
                children: shoppingCart.map( (cart) {
                  final currency = cart['currency'];
                  final quantity = cart['quantity'];
                  final total    = cart['total'];
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
                          image: Image.network(cart['image_url']).image,
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
                                cart['category'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.04
                                )
                              ),
                              Text(
                                cart['name'],
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.03
                                )
                              )                                                                                
                            ]
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                                  iconSize: 32.0,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      num price   = cart['price'];
                                      if (cart['quantity'].value > cart['minQuantity']) {
                                        cart['quantity'].value --;
                                        cart['total'].value = (cart['quantity'].value * price);
                                      }
                                    });
                                  },
                                ),
                                ValueListenableBuilder<int>(
                                  valueListenable: cart['quantity'], 
                                   builder: (BuildContext context, int value, Widget? child) {
                                    // This builder will only get called when the _counter
                                    // is updated.
                                    // final count = quantity.value;
                                    return Text(
                                      '$value',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }, 
                                ),                            
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                                  iconSize: 32.0,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    num price   = cart['price'];
                                    setState(() {
                                      quantity.value ++;
                                      cart['total'].value = (cart['quantity'].value * price);
                                    });
                                  },
                                ),
                              ],
                            ),
                        ),                          
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(10.0),
                          child: ValueListenableBuilder<num>(
                            valueListenable: cart['total'], 
                            builder: (BuildContext context, num value, Widget? child) {
                              return Text(
                                "$currency $value",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          ),
                        ),   
                        Container(
                          alignment: Alignment.topRight,
                          // padding: EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                            iconSize:  MediaQuery.of(context).size.width * 0.06,
                            color: Theme.of(context).primaryColor,
                            onPressed: () async{
                              final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
                              final cachedCart   = await cacheManager.get('shopping_cart');
                              
                              if( cachedCart != null ){
                                ( cachedCart.value as List ).removeWhere((item) => item['id'] == cart['id'] );
                                await cacheManager.add('shopping_cart', ( cachedCart.value as List ));
                              }

                              setState(() {
                                shoppingCart.removeWhere((item) => item['id'] == cart['id'] );
                              });

                            },
                          ),
                        ),                                                                                                                                                                                                                                                                  
                      ]
                    )
                  );
                }).toList()
              )
              : Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.9,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: const Icon(
                        Icons.block,
                        color: Colors.blueAccent,
                      ),                       
                    ),
                    Text(
                      'Nothing found here.',
                      style: GoogleFonts.poppins(
                        color: Colors.blueAccent,
                        fontSize: MediaQuery.of(context).size.width * 0.05
                      )
                    ),    
                  ]
                )
              )
          ),
        ),
      ),
    );
  }

  Future<void> fetchShoppingCart() async{
    
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final cart         = await cacheManager.get('shopping_cart');
    if( cart != null ){
      ( cart.value as List ).forEach((item) async { 
        String id      = item['id'];
        print(id);
        Provider.of<ApiService>(context,listen: false)
                .get(Uri.parse('cart/$id'.toString()))
                .then((response) {
                  print(response.body);
                  Map<String,dynamic> product = jsonDecode(response.body)['product'];
                  setState(() {
                    shoppingCart.add({
                      'id':          item['id'],
                      'name':        product['name'],
                      'category':    product['product_category']['name'],
                      'image_url':   product['image_url'],
                      'total':       ValueNotifier<num>(item['total']),
                      'quantity':    ValueNotifier<int>(item['quantity']),
                      'price':       item['price'],
                      'currency':    product['currency'],
                      'minQuantity': item['minQuantity']
                    });  
                    // shoppingCart.add(item);                  
                  });
                });
      });
    }
    
  }  
  
}