import 'dart:convert';

import 'package:android_app/services/api.service.dart';
import 'package:android_app/store/actions/user.action.store.dart';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.profile, required this.showDialogContext});

  Map<String,dynamic> profile;
  BuildContext showDialogContext;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  
  final TextEditingController _controllerFirstName   = TextEditingController();
  final TextEditingController _controllerLastName    = TextEditingController();
  final TextEditingController _controllerAddress     = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerPin         = TextEditingController();
  bool _loading                                      = false;

  @override
  void initState() {
    _controllerFirstName.text   = widget.profile['first_name'];
    _controllerLastName.text    = widget.profile['last_name'];
    _controllerAddress.text     = widget.profile['address']     ?? "";
    _controllerPhoneNumber.text = widget.profile['phone']       ?? "";
    _controllerPin.text         = widget.profile['kra_pin']     ?? "";
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width,
        child:  Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit Profile",
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.06
                        )
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)
                      )
                    ]
                  ),
                ),
                Container(
                  height:  MediaQuery.of(context).size.height * 0.8,
                  width:   MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: TextFormField(
                          controller: _controllerFirstName,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "First Name",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
            
                          },            
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: TextFormField(
                          controller: _controllerLastName,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
            
                          },            
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: TextFormField(
                          controller: _controllerAddress,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Address",
                            prefixIcon: const Icon(Icons.location_city),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
            
                          },            
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: TextFormField(
                          controller: _controllerPhoneNumber,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
            
                          },            
                        ),
                      ),   
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: TextFormField(
                          controller: _controllerPin,
                          // keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "KRA Pin",
                            prefixIcon: const Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
            
                          },            
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.blueAccent,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            updateProfile({
                              "first_name": _controllerFirstName.text,
                              "last_name":  _controllerLastName.text,
                              "address":    _controllerAddress.text,
                              "phone":      _controllerPhoneNumber.text,
                              "kra_pin":    _controllerPin.text,
                              "_method":    'POST'
                            },context);
                          },
                          child: _loading ? 
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ) 
                            : const Text("Save Changes",style: TextStyle(color: Colors.white),),
                        ),
                      )                                                                                                                                                                          
                    ]
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  Future<void> updateProfile(Map<String,dynamic> data, BuildContext context) async{
    
    try {
      setState(() {  _loading = true; });

      String userId      = widget.profile['id'];
      final store        = Provider.of<Store>(context,listen: false);
      final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
      Response response  = await Provider.of<ApiService>(context,listen: false)
                                        .put( 
                                          Uri.parse('/auth/$userId'.toString()),
                                          body: jsonEncode(data)
                                        );

      switch(response.statusCode){
        case 422:
          setState(() {  _loading = false; });

          Map<String,dynamic> data = jsonDecode(response.body);

          ScaffoldMessenger.of(widget.showDialogContext).showSnackBar(SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Row(
              children: [
                const Icon(
                  color: Colors.white,
                  Icons.info
                ),
                Flexible(
                  child: Text(
                    data['message'],
                    style: const TextStyle(color: Colors.white ),
                    )
                )
              ],
            ),
          ));          
          print(jsonDecode(response.body));
        break;
        case 200:
          setState(() {  _loading = false; });
          Map<String,dynamic> user = jsonDecode(response.body)['user'];
          store.dispatch(UpdateUser(user));     
          Navigator.pop(context);   
          ScaffoldMessenger.of(widget.showDialogContext).showSnackBar(const SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Row(
              children: [
                Icon(
                  color: Colors.white,
                  Icons.info
                ),
                Flexible(
                  child: Text(
                    'Your profile has been saved.',
                    style: TextStyle(color: Colors.white ),
                    )
                )
              ],
            ),
          ));          
        break;
      }

    } catch (e) {   

      print(e);
    
    }

  }
}