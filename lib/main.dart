import 'package:device_info/device_info.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_ecommerce/models/user.model.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';
import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/device.action.store.dart';
import 'package:redux/redux.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markholdings_ecommerce/screens/home.screen.dart';
// import 'package:markholdings_ecommerce/screens/splash.screen.dart';
import 'package:provider/provider.dart';

late Store<AppState> store;

Future<void> main() async {

  store = Store<AppState>(appReducer,initialState: AppState.initialState());

  await dotenv.load(fileName: "lib/.env");

  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  dynamic user                  = await UserModel().first();
  Map<String,String> headers    = { 
    "Content-Type":"application/json",
    "Accept":"application/json"
  };

  if( user.isNotEmpty ){
    String token             = user['token'];
    headers['Authorization'] = "Bearer $token";
  }


  store.dispatch(UpdateDevice({"name":androidInfo.model,"id":androidInfo.androidId}));
  store.dispatch(UpdateAuth({
    "exipryDate": "",
    "loading":    false,
    "token":      "",
    "user":       {}
  }));

  runApp(StoreProvider(
    store:store,
    child: MarkholdingsApp(user:user,headers: headers),
  ));

}

class MarkholdingsApp extends StatelessWidget{

  MarkholdingsApp({super.key,this.user,this.headers});

  final baseUrl = dotenv.env['BASE_URL'];
  final dynamic user;
  dynamic headers;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Store>( create: (_) => store ),
        Provider<ApiService>( create: (_) => ApiService(
            headers,
            "$baseUrl/api/android"
          )
        ),
      ],
      child: MaterialApp(
        initialRoute: '/home',
        routes: {
          // '/':     (context) => const SplashScreen(),
          '/home': (context) => Home(),
        },
        theme: ThemeData(fontFamily: 'Rubik')
      )
    );
  }
}