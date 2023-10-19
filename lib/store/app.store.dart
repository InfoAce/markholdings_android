import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/device.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/user.action.store.dart';

class AppState {

  // Authenticated user object
  late final Map<String,dynamic> _auth;

  // Get device info
  late final Map<String,dynamic> _device;

  // Get device info
  late final Map<String,dynamic> _user;

  // Initializa state
  AppState(this._auth,this._device,this._user);

  Map<String,dynamic> get auth => _auth;

  Map<String,dynamic> get device => _device;

  Map<String,dynamic> get user => _user;

  AppState.initialState() : 
    _auth = {
      "token": "",
    }, 
    _device = {
      "id"  :  "",
      "name":  ""
    },
    _user = {};

}

// Initialize application state reducer
AppState appReducer(AppState state, dynamic action) {
  // Check the type of action provided
  if( action is UpdateDevice){
    return AppState(state.auth,action.device,state.user);
  }
  if( action is UpdateAuth){
    return AppState(action.auth,state.device,state.user);
  } 
  if( action is UpdateUser){
    return AppState(state.auth,state.device,action.user);
  }   
  return state;
}