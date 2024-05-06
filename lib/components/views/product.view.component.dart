import 'dart:async';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:android_app/store/actions/product.action.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductView extends StatefulWidget {
  ProductView({super.key,required this.product});

  final Map<String,dynamic> product;
  int minQuantity = 1;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  
  ValueNotifier<num> quantity = ValueNotifier<num>(1);

  ValueNotifier<num> total = ValueNotifier<num>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: TextButton(
            style: const ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),           
            onPressed: () {
              final store   = Provider.of<Store>(context,listen: false);   
              store.dispatch(ViewProduct({}));                  
            }, 
            child: const Icon(Icons.chevron_left),
          ),
      ),
      body:  Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueAccent
                    ),
                    child: Text(
                      widget.product["currencyPrice"],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),                
              ]
            )     
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration:  const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['product_category']['name'],
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product['name'],
                              style: GoogleFonts.poppins(
                                color: Colors.blueAccent,
                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.02 ),
                        Html(data: widget.product['description']),
                        // Html(data: widget.product['description']),
                        // HtmlWidget(widget.product['description']),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.02 ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Client Reviews",
                              style: GoogleFonts.poppins(
                                color: Colors.blueAccent,
                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            MaterialButton(
                              onPressed: (){},                              
                              child: Text(
                                "View all",
                                style: GoogleFonts.poppins(
                                  color: Colors.blueAccent,
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                              ),
                            ),
                            )                                                                                 
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.02 ),
                        widget.product['activeReviews']['data'].isNotEmpty ?
                          Column(
                            children: widget.product['activeReviews']['data'].map<Widget>( (review) {
                              final String first_name = review['user']['first_name'];
                              final String last_name  = review['user']['last_name'];
                              final DateTime dateTime = DateTime.parse(review['created_at']);
                              final String created_at = DateFormat('dd MMMM yyyy').format(dateTime);
                              return Card(
                                margin: EdgeInsets.all(5.0),
                                clipBehavior: Clip.hardEdge,
                                child:  Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(children: [
                                    Text(
                                      review['comment'],
                                      style: GoogleFonts.poppins(
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ),                                      
                                    ),
                                    Text(
                                      "$created_at",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[500],
                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                      ),                                      
                                    ),                                    
                                    SizedBox(height: MediaQuery.of(context).size.width * 0.02 ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: Image.network(review['user']['profile_photo_url']).image,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0 ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "$first_name $last_name",
                                                style: GoogleFonts.poppins(
                                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                ),                                      
                                              ),                                                                                      
                                            ],
                                          ),
                                        ), 
                                      ],
                                    )                                                                     
                                  ],)
                                )
                              );
                            }).toList(),
                          ) : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child:  Text(
                                  "No reviews yet.",
                                  style: GoogleFonts.poppins(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                  ),                                      
                                ),  
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),          
        ]
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5.0),
        child: TextButton(
          onPressed: (){
            setState(() {
              num price  = widget.product['price'];
              total.value = (quantity.value * price);
            });
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
          }, 
          style:  ButtonStyle(
            shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.blueAccent, // your color here
                      width: 1,
                    ),
                ),
            )
          ),             
          isSemanticButton: true,
          child: Container(
            // color: Colors.blueAccent,
            padding: EdgeInsets.all(10.0),
            child: Text(
                "Add to cart",
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                  fontSize: MediaQuery.of(context).size.width * 0.03
                )
            ),
          )
        )        
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

  }

}