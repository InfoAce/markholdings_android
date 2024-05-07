import 'dart:convert';
import 'dart:ffi';

import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app/services/api.service.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class CheckoutView extends StatefulWidget {

  CheckoutView({super.key,required this.items, required this.clearItems});

  List<dynamic> items = [];
  Function clearItems;
  
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  final TextEditingController _controllerDeliveryDetails  = TextEditingController();

  final List<String> _paymentOptions         = ["Cash", "Credit" ];
  final List<String> _deliveryOptions        = ["Courier", "Pickup" ];
  Store? store;
  List<Map<String,dynamic>> _pickupLocations = [];
  String currency                            = "";

  ValueNotifier<int> totalQuantity           = ValueNotifier<int>(0);
  ValueNotifier<int> totalAmount             = ValueNotifier<int>(0);

  String _paymentOption   = "";
  ValueNotifier<String> _deliveryOption  = ValueNotifier<String>("");
  String _deliveryDetails = "";
  String _pickupLocation  = "";

  bool _loading = false;

  @override
  void initState(){
    
    super.initState();
    getLocations();

    store = Provider.of<Store>(super.context,listen:false);

    setState(() {
      currency            = store?.state.user['currency'];
      totalQuantity.value = widget.items.map((item) => item['quantity'].value ).reduce((value, element) => value + element);
      totalAmount.value   = widget.items.map((item) => ( item['quantity'].value * item['price']) ).reduce((value, element) => value + element);
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.01 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                        child: Icon(
                          size: MediaQuery.of(context).size.width * 0.06,
                          Icons.shopping_cart_checkout,
                          color: Colors.blueAccent,
                        ),                       
                      ),
                      Text(
                          "Checkout",
                          style: GoogleFonts.poppins(
                            color: Colors.blueAccent,
                            fontSize: MediaQuery.of(context).size.width * 0.06
                          )
                      ),
                    ]
                  ),
                  TextButton(
                    onPressed: () {
                      // Timer.periodic(const Duration(seconds: 1), (timer) {
                      //   timer.cancel();
                      //   quantity.value = 1;
                      // });
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close)
                  )                              
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Total Quantity",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.04
                    )
                ),
                ValueListenableBuilder(
                  valueListenable: totalQuantity, 
                  builder: (BuildContext context, int value, Widget? child) {     
                    return Text(
                        value.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.035
                        )
                    );
                  },
                ),                               
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Total Amount",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.04
                    )
                ),
                ValueListenableBuilder(
                  valueListenable: totalAmount, 
                  builder: (BuildContext context, int value, Widget? child) {     
                    return Text(
                        currency + " " + value.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.035
                        )
                    );
                  },
                ),                
              ],
            ),  
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.03,
                top: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.03,
                    ),                    
                    child: Text(
                        "Purchase details",
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.05
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                    ),   
                    width: MediaQuery.of(context).size.width,         
                    child: DropdownButtonFormField(                      
                      decoration: InputDecoration(
                        labelText: "Payment Option",
                        focusColor: Colors.blueAccent,
                        prefixIcon: const Icon(Icons.payments),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true
                      ),
                      items: _paymentOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(), 
                      onChanged: (value) {
                        setState(() {
                          _paymentOption = ( value as String).toLowerCase();
                        });
                      }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.04,
                    ),   
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Delivery Option",
                        focusColor: Colors.blueAccent,
                        prefixIcon: const Icon(Icons.delivery_dining),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true
                      ),
                      items: _deliveryOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(), 
                      onChanged: (value) {
                        setState(() {
                          _deliveryOption.value = ( value as String).toLowerCase();
                        });
                      }
                    ),
                  ), 
                  ValueListenableBuilder<String>(
                    valueListenable: _deliveryOption, 
                    builder: (BuildContext context, String value, Widget? child) {                    
                          if( value == 'pickup'){
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.width * 0.04,
                              ),   
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  focusColor: Colors.blueAccent,
                                  labelText: "Pickup Locations",
                                  prefixIcon: const Icon(Icons.location_pin),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  isDense: true
                                ),
                                items: _pickupLocations.map<DropdownMenuItem<dynamic>>((dynamic value) {
                                  final name = value['name'];
                                  return DropdownMenuItem(
                                    value: value['id'],
                                    child: Text(
                                      name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                }).toList(), 
                                onChanged: (option) {
                                  setState(() {
                                    _pickupLocation = option;
                                  });
                                }
                              ),
                            );                        
                          }

                          if( value == 'courier'){
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.width * 0.04,
                              ),                       
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                child: TextFormField(
                                  controller: _controllerDeliveryDetails,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null, //Set this 
                                  expands: true,
                                  // minLines: 1,
                                  decoration: InputDecoration(
                                    focusColor: Colors.blueAccent,
                                    labelText: "Delivery Details",
                                    prefixIcon: const Icon(Icons.info),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    isDense: true
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      _deliveryDetails = text;
                                    });        
                                  },            
                                ),
                              ),
                            );      
                          }
                          return SizedBox();                  
                    }
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {

                        if(  _paymentOption.isNotEmpty && _deliveryOption.value.isNotEmpty || (_deliveryOption.value == 'courier' ? _pickupLocation.isNotEmpty : _deliveryDetails.isNotEmpty )  ){   
                          if( !_loading ){                                                    
                            submit();
                          }                       
                        }  
                        
                        if( _paymentOption.isEmpty && _deliveryOption.value.isEmpty || (_deliveryOption.value == 'courier' ? _pickupLocation.isEmpty : _deliveryDetails.isEmpty  ) ){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.amber,
                            content: Row(
                              children: [
                                Icon(
                                  color: Colors.white,
                                  Icons.info
                                ),
                                Flexible(
                                  child: Text(
                                    'There is a missing field. Please check your form.',
                                    style: TextStyle(color: Colors.white) 
                                  )
                                )
                              ],
                            ),
                          ));
                        }
                      },
                      child: _loading ? 
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ) 
                        : const Text("Place Order", style: TextStyle( color: Colors.white) ),
                    ),
                  )                                                                           
                ],
              ),
            )          
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {

    Map<String,dynamic> data = {
      "deliveryOption": _deliveryOption.value,
      "items":          widget.items.map((item) => { "id": item['id'], "quantity": item['quantity'].value, "price": item['price'], "total": item['total'].value }).toList(),
      "paymentOption":  _paymentOption,
    };

    if( _deliveryOption.value == "courier" ){
      data['deliveryDetails'] = _deliveryDetails;
    } else if( _deliveryOption.value == "pickup" ){
      data['pickupLocation'] = _pickupLocation;
    }

    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);

    setState(() => _loading = true);

    Response response = await Provider.of<ApiService>(context,listen: false)
                                      .post(
                                        Uri.parse('/cart/order'.toString()),
                                        body: jsonEncode(data)
                                      );
    
    setState(() => _loading = false);

    switch(response.statusCode){
      case 200:
        setState(() => _loading = false);    
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Row(
            children: [
              Icon(
                color: Colors.white,
                Icons.info
              ),
              Flexible(
                child: Text('Your order has been received. You will be notified of the order soon.',
                style: TextStyle(color: Colors.white) 
                )
              )
            ],
          ),
        ));    
        widget.clearItems();
        await cacheManager.remove('shopping_cart');
      break;
      default: 
        setState(() => _loading = false);
    }                                 

  }

  Future<void> getLocations() async{
    final auth  = store?.state.auth;

    Provider.of<ApiService>(context,listen: false)
        .get(
          Uri.parse('cart/locations'.toString()),
        )
        .then((response) { 
          switch(response.statusCode){
            case 200:
              final locations = jsonDecode(response.body)['locations'];
              locations.forEach((location){
                _pickupLocations.add({
                  "id": location['id'],
                  "name": location['name']
                });
              });
            break;
          }
        });
  }
}