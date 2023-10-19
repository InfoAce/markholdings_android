import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/screens/home.screen.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/validations/company.validation.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late ApiService api;
  late String logo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    api   = Provider.of<ApiService>(context);
    return MaterialApp(
      home: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                FutureBuilder<CompanyValidation>(
                  future:  fetchSplashScreen(),
                  builder: (context,snapshot) {
                  if (snapshot.hasData) {
                      delayNavigation(context);
                      return Image.network(
                        snapshot.data!.company['logo_url'],
                        height: 150,
                        fit:BoxFit.fill
                      );
                    } else if (snapshot.hasError) {
                      // return Text('${snapshot.error}');
                    }                  
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
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
  
  Future<CompanyValidation> fetchSplashScreen() async{ 
    
    final response = await api.get(Uri.parse('company'.toString()));
    
    if( response.statusCode == 200 ){
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      return CompanyValidation.fromJson(jsonDecode(response.body));
    }  else {
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      throw Exception("Something went wrong.");
    }

  }

  Future<void> delayNavigation(context) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home())
    );
  }
}