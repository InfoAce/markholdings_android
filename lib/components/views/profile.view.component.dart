import 'dart:convert';
import 'dart:io';
import 'package:android_app/components/builders/base/edit.profile.builder.dart';
import 'package:android_app/services/api.service.dart';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:android_app/store/actions/auth.action.store.dart';
import 'package:android_app/store/actions/user.action.store.dart';
import 'package:android_app/store/app.store.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  ValueNotifier<String> profileImage                 = ValueNotifier<String>('');
  ValueNotifier<String> _                 = ValueNotifier<String>('');
  
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
        final pin               = state.user['kra_pin'];
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
                            return EditProfile(profile: state.user);
                          }
                        ); 
                        
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
                         _logout(context);
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
                        'Kra Pin',
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
                          '$pin',
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

                    var storageStatus = await Permission.storage.status;

                    if( storageStatus.isDenied ){
                      await Permission.storage.request();
                    }

                    if( storageStatus.isGranted ){

                      final ImagePicker picker = ImagePicker();
                      final XFile? image       = await picker.pickImage(source: ImageSource.gallery);

                      if( image != null){
                        // selectedImages.add(image);
                        setState(() {
                          profileImage.value = image.path;                        
                        });
                      }
              
                    }
                  },
                  child: ValueListenableBuilder<String> (
                    valueListenable: profileImage,
                    builder: (BuildContext context, String value,child) {

                      if( value.isNotEmpty ){
                        uploadImage(context);
                      }

                      return value.isNotEmpty ? CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.07,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.07,
                          backgroundImage: Image.file(File(value)).image,
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
                      ) : CircleAvatar(
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
                        );
                    },
                  ),
                ),
              )
            ),
          ]
        );
      },
      converter:(store) => store.state,
    );
  }

 Future<dynamic> uploadImage(BuildContext context) async {

    final store        = Provider.of<Store>(context,listen: false);
    String? mimeType   = lookupMimeType(profileImage.value);
    String base64Image = base64.encode(File(profileImage.value).readAsBytesSync());

    final response     = await Provider.of<ApiService>(context,listen: false)
                                       .post(
                                        Uri.parse('/auth/upload/image'.toString()),
                                        body: jsonEncode({ "base64Image": base64Image, "mimeType": mimeType })
                                       );                          

    switch(response.statusCode){
      case 200:
        Map<String,dynamic> data = jsonDecode(response.body);
        store.dispatch(UpdateUser(data['user']));         
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Row(
            children: [
              Icon(
                color: Colors.white,
                Icons.check_circle_rounded,
              ),
              Flexible(
                child: Text(
                  'Profile image has been updated.',
                  style: TextStyle(color: Colors.white) 
                )
              )
            ],
          ),
        ));      
        setState(() { profileImage.value = ""; });      
      break;
      case 422:
      break;
    }
  }

  Future<void> _logout(BuildContext context) {
    
    final store = Provider.of<Store>(context,listen:false);
    final cache = Provider.of<DataCacheManager>(context,listen:false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:   const Text('Are you sure ?'),
          content: const Text("You are about to logout."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor:  Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Yes', style: TextStyle(color: Colors.white)),
              onPressed: () {
                cache.remove('auth');

                store.dispatch(UpdateUser({}));
                store.dispatch(UpdateAuth({}));

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