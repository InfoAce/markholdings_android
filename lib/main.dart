
import 'dart:convert';

import 'package:android_app/screens/verification.screen.dart';
import 'package:android_app/store/actions/user.action.store.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:android_app/store/actions/env.action.store.dart';
import 'package:android_app/store/actions/tab.action.store.dart';
import 'package:android_app/store/app.store.dart';
import 'package:android_app/store/actions/auth.action.store.dart';
import 'package:redux/redux.dart';
import 'package:android_app/services/api.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:android_app/screens/home.screen.dart';
import 'package:provider/provider.dart';
import 'package:data_cache_manager/data_cache_manager.dart';

late Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DataCacheManager cacheManager = DefaultDataCacheManager.instance;
  CachedData? authStore         = await cacheManager.get('auth');
  Map<String,dynamic> auth      = authStore != null ? jsonDecode(authStore.value.toString()) : {};

  store = Store<AppState>(appReducer,initialState: AppState.initialState());

  await dotenv.load(fileName: "lib/.env");

  dynamic user                  = {};
  Map<String,String> headers    = { 
    "Content-Type": "application/json; charset=utf-8",
    "Accept":       "application/json"
  };

  if( auth.isNotEmpty && auth.containsKey('token') ){
          
    store.dispatch(UpdateAuth(auth['token']));
    
    store.dispatch(UpdateUser(auth['user']));
      
    headers['Authorization'] = auth['token']['token_type'] + ' ' + auth['token']['access_token'];
  }
  
  store.dispatch(UpdateAuth({})); 

  store.dispatch(UpdateEnv({...dotenv.env}));

  store.dispatch(UpdateTab(0));

  runApp(StoreProvider(
    store:store,
    child: MarkholdingsApp(cache:cacheManager, headers: headers),
  ));

}

class MarkholdingsApp extends StatelessWidget{

  MarkholdingsApp({super.key,required this.cache,this.headers});

  final baseUrl          = dotenv.env['BASE_URL'];
  DataCacheManager cache;
  dynamic headers;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Store>( create: (_) => store ),
        Provider<DataCacheManager>( create: (_) => cache ),
        Provider<ApiService>( create: (_) => ApiService(
            headers,
            "$baseUrl/api/android"
          )
        ),
      ],
      child: MaterialApp(
        initialRoute: 'home',
        routes: {
          'home':         (context) => const Home(),
          'verification': (context) => VerificationScreen()
          // '/':     (context) => const SplashScreen(),
        },
        theme: ThemeData(fontFamily: 'Rubik')
      )
    );
  }
  
}
