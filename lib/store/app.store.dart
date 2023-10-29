import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/device.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/env.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/product.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/user.action.store.dart';

class AppState {

  // Authenticated user object
  late final Map<String,dynamic> _auth;

  // Get device info
  late final Map<String,dynamic> _device;

  // Get device info
  late final Map<String,dynamic> _env;

  // Get user info
  late final Map<String,dynamic> _user;

    // Get product info
  late final Map<String,dynamic> _product;

  // Initializa state
  AppState(this._auth,this._device,this._env,this._user,this._product);

  Map<String,dynamic> get auth => _auth;

  Map<String,dynamic> get device => _device;

  Map<String,dynamic> get env => _env;

  Map<String,dynamic> get user => _user;

  Map<String,dynamic> get product => _product;

  AppState.initialState() : 
    _auth = {
      "token": "",
    }, 
    _env =  {},
    _device = {
      "id"  :  "",
      "name":  ""
    },
    _user = {},
    _product = {};

}

// Initialize application state reducer
AppState appReducer(AppState state, dynamic action) {
  // Check the type of action provided
  if( action is UpdateAuth){
    return AppState(
      action.auth,
      state.device,
      state.env,
      state.user,
      state.product
    ); 
  } 
  if( action is UpdateDevice){
    return AppState(
      state.auth,
      action.device,
      state.env,
      state.user,
      state.product
    );
  }
  if( action is UpdateEnv){
    return AppState(
      state.auth,
      state.device,
      action.env,
      state.user,
      state.product
    );
  }    
  if( action is UpdateUser){
    return AppState(
      state.auth,
      state.device,
      state.env,
      action.user,
      state.product
    );  
  }  
  if( action is ViewProduct){
    return AppState(
      state.auth,
      state.device,
      state.env,
      state.user,
      action.product
    );
  }   
  return state;
}