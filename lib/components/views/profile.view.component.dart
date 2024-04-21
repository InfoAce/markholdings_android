import 'dart:io';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/user.action.store.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  final TextEditingController _controllerFirstName   = TextEditingController();
  final TextEditingController _controllerLastName    = TextEditingController();
  final TextEditingController _controllerAddress     = TextEditingController();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerPin         = TextEditingController();
  // ValueNotifier<String> profileImage                 = ValueNotifier<String>('');
  
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,AppState>(
      builder: (context,AppState state) {
        final firstName         = state.user['first_name'];
        final lastName          = state.user['last_name'];
        final phone             = state.user['phone'];
        final address           = state.user['address'];
        final type              = state.user['type'];
        final email             = state.user['email'];
        final pic               = state.user['photo_url'];
        final DateTime dateTime = DateTime.parse(state.user['created_at']);
        final String joinedOn   = DateFormat('dd MMMM yyyy').format(dateTime);
        return Stack(
          children: [
            Container(
              height:MediaQuery.of(context).size.height * 0.2 ,
              padding: EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        iconSize: MediaQuery.of(context).size.width * 0.05,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.90,
                              width: MediaQuery.of(context).size.width,
                              child:  Container(
                                padding: EdgeInsets.all(15.0),
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
                                      height:  MediaQuery.of(context).size.height * 0.2,
                                      width:   MediaQuery.of(context).size.width,
                                      child: Stack(
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
                                              controller: _controllerFirstName,
                                              // keyboardType: TextInputType.name,
                                              decoration: InputDecoration(
                                                labelText: "Email",
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
                                              controller: _controllerFirstName,
                                              // keyboardType: TextInputType.name,
                                              decoration: InputDecoration(
                                                labelText: "Email",
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
                                              controller: _controllerFirstName,
                                              // keyboardType: TextInputType.name,
                                              decoration: InputDecoration(
                                                labelText: "Email",
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
                                        ]
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        ); 
                          // num price   = cart['price'];
                          // setState(() {
                          //   quantity.value ++;
                          //   cart['total'].value = (cart['quantity'].value * price);
                          // });
                        },
                      ),              
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        iconSize: MediaQuery.of(context).size.width * 0.05,
                        color: Theme.of(context).primaryColor,
                        onPressed: () async{
                          final store = Provider.of<Store>(context,listen:false);
                          final cache = Provider.of<DataCacheManager>(context,listen:false);

                          await cache.remove('auth');

                          store.dispatch(UpdateUser({}));
                          store.dispatch(UpdateAuth({}));
                        },
                      ),
                    ],
                  ),
                ]
              )
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
              width:  MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.03,
                top: MediaQuery.of(context).size.height * 0.1
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                     
                      Text(
                        'Name',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$firstName $lastName',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),                      
                      Text(
                        'Email Address',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$email',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ), 
                      Text(
                        'Phone Number',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$phone',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),    
                      Text(
                        'Address',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$address',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Account Type',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$type',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Joined On',
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ), 
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                          top: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Text(
                          '$joinedOn',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),                                                                                                                                                              
                  ],
                ),
              )
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13),
              child: SizedBox(
                child: InkWell(
                  onTap:  () async {
                    print('here');
                    var storageStatus = await Permission.storage.status;

                    if( storageStatus.isDenied ){
                      await Permission.storage.request();
                    }

                    if( storageStatus.isGranted ){

                      // final ImagePicker picker = ImagePicker();
                      // final XFile? image       = await picker.pickImage(source: ImageSource.gallery);

                      // if( image != null){
                      //   // selectedImages.add(image);
                      //   setState(() {
                      //     profileImage.value = image.path;                        
                      //   });
                      // }
                    
                    }

                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.07,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.07,
                      backgroundImage: Image.network(pic).image,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: MediaQuery.of(context).size.height * 0.018,
                          child: Icon(
                            Icons.camera_alt,
                            size: MediaQuery.of(context).size.height * 0.016,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  )
                  // child: ValueListenableBuilder<String> (
                  //   valueListenable: profileImage,
                  //   builder: (BuildContext context, String value,child) {
                  //     return CircleAvatar(
                  //       radius: MediaQuery.of(context).size.height * 0.07,
                  //       backgroundColor: Colors.white,
                  //       child: CircleAvatar(
                  //         radius: MediaQuery.of(context).size.height * 0.07,
                  //         backgroundImage: Image.network(pic).image,
                  //         child: Align(
                  //           alignment: Alignment.bottomRight,
                  //           child: CircleAvatar(
                  //             backgroundColor: Colors.white,
                  //             radius: MediaQuery.of(context).size.height * 0.018,
                  //             child: Icon(
                  //               Icons.camera_alt,
                  //               size: MediaQuery.of(context).size.height * 0.016,
                  //               color: Colors.grey.shade600,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              )
            ),
          ]
        );
      },
      converter:(store) => store.state,
    );
  }
}