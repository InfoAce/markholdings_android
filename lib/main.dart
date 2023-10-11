import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_android/states/actions/update_auth.dart';
import 'package:markholdings_android/states/actions/update_device.dart';
import 'package:markholdings_android/states/actions/update_home.dart';
import 'package:markholdings_android/states/app_state.dart';
import 'package:redux/redux.dart';
import 'package:markholdings_android/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markholdings_android/views/home.dart';
import 'package:markholdings_android/views/splash_screen.dart';
import 'package:provider/provider.dart';

late Store<AppState> store;

Future<void> main() async {

  store = Store<AppState>(appReducer,initialState: AppState.initialState());

  await dotenv.load(fileName: "lib/.env");

  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

  store.dispatch(UpdateDevice({"name":androidInfo.model,"id":androidInfo.androidId}));
  store.dispatch(UpdateAuth({
    "exipryDate": "",
    "loading":    false,
    "token":      "",
    "user":       {}
  }));
  store.dispatch(UpdateHome({
    "tab": 0
  }));

  runApp(StoreProvider(
    store:store,
    child: const MarkholdingsApp(),
  ));

}

class MarkholdingsApp extends StatelessWidget{

  const MarkholdingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Store>( create: (_) => store ),
        Provider<ApiService>( create: (_) => ApiService({"Content-Type":"application/json","Accept":"application/json"},dotenv.env['API_URL'].toString())),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/':     (context) => const SplashScreen(),
          '/home': (context) => const Home(),
        },
        theme: ThemeData(fontFamily: 'Rubik')
      )
    );
  }
}