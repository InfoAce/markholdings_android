import 'dart:convert';

import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app/components/views/checkout.view.component.dart';
import 'package:android_app/services/api.service.dart';
import 'package:android_app/store/actions/tab.action.store.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:redux/redux.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {

  ValueNotifier<List> shoppingCart     = ValueNotifier<List>([]);

  @override
  void initState(){
    super.initState();
    fetchShoppingCart(super.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StickyHeader(
          header: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
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
                      if( shoppingCart.value.isNotEmpty) {
                        popup(context);
                      }

                      if( shoppingCart.value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.blueAccent,
                          content: Row(
                            children: [
                              Icon(
                                color: Colors.white,
                                Icons.info
                              ),
                              Flexible(
                                child: Text('Your shopping cart is empty.',
                                style: TextStyle(color: Colors.white) 
                                )
                              )
                            ],
                          ),
                        ));    
                      }                      
                      
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
            child: ValueListenableBuilder(
              valueListenable: shoppingCart,
              builder: (BuildContext context, List<dynamic> value, Widget? child) {    
                return value.isNotEmpty ?
                  Column(
                    children: value.map( (cart) {
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
                              padding: const EdgeInsets.all(10.0),
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
                              padding: const EdgeInsets.all(10.0),
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
                              padding: const EdgeInsets.all(10.0),
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
                                onPressed: () {
                                  _showMyDialog(cart,context);                            
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
                  );
              } 
            )
          ),
        ),
      ),
    );
  }
  
  Future<void> popup(BuildContext context) async{
    final store = Provider.of<Store>(context,listen: false);
    final user  = store.state.user;

    if( user.isNotEmpty ){
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CheckoutView(items: shoppingCart.value,clearItems: () => shoppingCart.value.clear() ),
        );
      });
    } else {
      store.dispatch(UpdateTab(3));
    }
  }

  Future<void> fetchShoppingCart(BuildContext context) async{
    
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final cart         = await cacheManager.get('shopping_cart');
    if( cart != null ){
      ( cart.value as List ).forEach((item) async { 
        String id      = item['id'];
        Provider.of<ApiService>(context,listen: false)
                .get(Uri.parse('cart/$id'.toString()))
                .then((response) {
                  Map<String,dynamic> product = jsonDecode(response.body)['product'];
                  setState(() {
                    shoppingCart.value.add({
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

  Future<void> _showMyDialog(cart, BuildContext context) async {
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: Text("You are about to remove " + cart['name'] + " from the cart list. This process is irreversible."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:  Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Yes', style: TextStyle(color: Colors.white)),
              onPressed: () async{
                final cachedCart   = await cacheManager.get('shopping_cart');
                
                if( cachedCart != null ){
                  ( cachedCart.value as List ).removeWhere((item) => item['id'] == cart['id'] );
                  await cacheManager.add('shopping_cart', ( cachedCart.value as List ));
                }

                setState(() {
                  shoppingCart.value.removeWhere((item) => item['id'] == cart['id'] );
                });

                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:  Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),              
              child: const Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () async{
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  
}