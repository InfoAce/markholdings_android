import 'dart:convert';
// import 'package:AestheticDialogs/AestheticDialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:markholdings_android/views/home.dart';
import 'dart:developer' as developer;
import 'package:provider/provider.dart';
import 'package:markholdings_android/views/validation/splash_screen_validation.dart';
import 'package:markholdings_android/views/home.dart';
import 'package:markholdings_android/services/api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late ApiService api;
  late String logo;
  late Future<SplashScreenValidation> fetch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    api   = Provider.of<ApiService>(context);
    fetch = fetchSplashScreen();
    return MaterialApp(
      home: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              children: [
                FutureBuilder<SplashScreenValidation>(
                  future: fetch,
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
  
  Future<SplashScreenValidation> fetchSplashScreen() async{ 
    
    final response = await api.get(Uri.parse('company'.toString()));
    
    if( response.statusCode == 200 ){
      // If the server did not return a 200 OK response,
      // then throw an exception.      
      return SplashScreenValidation.fromJson(jsonDecode(response.body));
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
      MaterialPageRoute(builder: (context) => const Home())
    );
  }
}