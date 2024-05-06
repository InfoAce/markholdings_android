import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:android_app/services/api.service.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class CheckoutView extends StatefulWidget {

  CheckoutView({super.key,required this.items});

  List<dynamic> items = [];

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  final TextEditingController _controllerDeliveryDetails  = TextEditingController();

  final List<String> _paymentOptions         = ["Cash", "Credit" ];
  final List<String> _deliveryOptions        = ["Courier", "Pickup" ];
  List<Map<String,dynamic>> _pickupLocations = [];

  String _paymentOption   = "";
  ValueNotifier<String> _deliveryOption  = ValueNotifier<String>("");
  String _deliveryDetails = "";
  String _pickupLocation  = "";

  bool _loading = false;

  @override
  void initState(){
    getLocations();
    super.initState();
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
                Text(
                    "Checkout",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.035
                    )
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
                Text(
                    "Checkout",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.035
                    )
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _paymentOption.isEmpty || _deliveryOption.value.isEmpty || (_deliveryOption.value == 'courier' ? _pickupLocation.isEmpty : _deliveryDetails.isEmpty )  || _loading ? Colors.grey[400] : Colors.blueAccent,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if(  _paymentOption.isNotEmpty && _deliveryOption.value.isNotEmpty || (_deliveryOption.value == 'courier' ? _pickupLocation.isNotEmpty : _deliveryDetails.isNotEmpty )  ){   
                        if( !_loading ){                                                    
                          submit();
                        }                       
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Row(
                            children: [
                              Icon(
                                color: Colors.white,
                                Icons.info
                              ),
                              Text('There is a missing field. Please check your form.')
                            ],
                          ),
                        ));
                      }
                    },
                    child: _loading ? 
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ) 
                      : const Text("Order"),
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
      "items":          widget.items.map((item) => { "id": item['id'], "quantity": item['quantity'].value, "total": item['total'].value }).toList(),
      "paymentOption":  _paymentOption,
    };

    if( _deliveryOption.value == "courier" ){
      data['deliveryDetails'] = _deliveryDetails;
    } else if( _deliveryOption.value == "pickup" ){
      data['pickupLocation'] = _pickupLocation;
    }

    setState(() => _loading = true);
   
    Provider.of<ApiService>(context,listen: false)
            .post(
              Uri.parse('/cart/order'.toString()),
              body: data
            )
            .then((response) { 
                print(response.body);
                switch(response.statusCode){
                  case 200:
                  break;
                }              
            })
            .catchError( (error) {
              setState(() => _loading = false);
            });

  }

  Future<void> getLocations() async{
    final store = Provider.of<Store>(context,listen: false);
    final auth  = store.state.auth;

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