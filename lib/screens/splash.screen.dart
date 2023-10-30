import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/main.dart';
import 'package:markholdings_ecommerce/screens/home.screen.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/validations/company.validation.dart';
import 'package:markholdings_ecommerce/validations/profile.validation.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late Map<String,dynamic> company = {};
  List<Widget> _children           = [];
  late dynamic user                = {};
  late String logo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();    
  }

  @override
  void didChangeDependencies(){
    initData(context);
  }

  Future<void> initData(context) async{
    Future.wait([ 
            Provider.of<ApiService>(context).get(Uri.parse('company'.toString())),
            Provider.of<ApiService>(context).get(Uri.parse('auth/profile'.toString()))
          ])
          .then( (response) {

            if( response[0].statusCode == 200 ){
              // If the server did not return a 200 OK response,
              // then throw an exception.      
              setState(() {
                company = CompanyValidation.fromJson(jsonDecode(response[0].body)).company;                
              });
            } 

            if( response[1].statusCode == 200 ){
              // If the server did not return a 200 OK response,
              // then throw an exception.      
              final user  = ProfileValidation.fromJson(jsonDecode(response[1].body));
              final store = Provider.of<Store>(context,listen: false);
              // store.dispatch(
              //   UpdateAuth({
              //     "token": store.state.auth['token'],
              //     "user":  user               
              //   })
              // );
            }  

            if(response[1].statusCode == 401 ) {
              // If the server did not return a 200 OK response,
              // then throw an exception.    
              if( user.isNotEmpty ){
                refreshToken();
              }
            }   

            if( response[0].statusCode >= 400) {
              Alert(
                context: context, 
                type: AlertType.warning,
                title: "Something went wrong.", 
                desc: "An error occurred while contacting the server. Please report the issue to the administrator."
              ).show(); 
            }

          })
          .whenComplete(() {
            Future.delayed(Duration(seconds: 2),() {
              Navigator.pushNamed(context, 'home');
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                company.isNotEmpty ? 
                  Image.network(
                    company['logo_url'],
                    height: 150,
                    fit:BoxFit.fill
                  )               
                : const CircularProgressIndicator(
                  color: Colors.white,
                ),               
                const Padding(padding: EdgeInsets.only(bottom: 10.0,top:10.0)),   
                const DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Rubik',
                      color: Colors.blueAccent
                  ),
                  child: Text("Markholdings"),
                ),                  
              ],
            )
          )
        )
      )
    );
  }
  
  Future<dynamic> refreshToken() async{ 
    final store    = Provider.of<Store>(context,listen: false);
    final response = await Provider.of<ApiService>(context)
                                   .post(
                                    Uri.parse('auth/refresh'.toString()),
                                    body:{
                                      "token":         user['refresh_token'],
                                      "client_id":     store.state.env['OAUTH_ID'],
                                      "client_secret": store.state.env['OAUTH_SECRET'],                                      
                                    }
                                   );
    
    if( response.statusCode == 200 ){
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      return ProfileValidation.fromJson(jsonDecode(response.body));
    }  else {
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      // Alert(
      //   context: buildContext, 
      //   title: "RFLUTTER", 
      //   desc: "Flutter is awesome."
      // ).show();
    }

  }
}