
import 'dart:convert';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_ecommerce/store/actions/env.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/tab.action.store.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';
import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:redux/redux.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:markholdings_ecommerce/screens/home.screen.dart';
import 'package:provider/provider.dart';
import 'package:data_cache_manager/data_cache_manager.dart';

late Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final _manager = DefaultDataCacheManager.instance;
  final auth     = await _manager.get('auth');

  store = Store<AppState>(appReducer,initialState: AppState.initialState());

  await dotenv.load(fileName: "lib/.env");

  dynamic user                  = {};
  Map<String,String> headers    = { 
    "Content-Type":"application/json",
    "Accept":"application/json"
  };

  if( auth != null ){
    final authorized = jsonDecode(auth.value.toString())['token'];
    headers[authorized['token_type']] = authorized['access_token'];
  }
  
  store.dispatch(UpdateAuth({})); 

  store.dispatch(UpdateEnv({...dotenv.env}));

  store.dispatch(UpdateTab(0));

  runApp(StoreProvider(
    store:store,
    child: MarkholdingsApp(cache:_manager, headers: headers),
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
          'home': (context) => const Home(),
          // '/':     (context) => const SplashScreen(),
        },
        theme: ThemeData(fontFamily: 'Rubik')
      )
    );
  }
  
}