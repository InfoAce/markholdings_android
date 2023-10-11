import 'package:markholdings_android/states/actions/update_auth.dart';
import 'package:markholdings_android/states/actions/update_device.dart';
import 'package:markholdings_android/states/actions/update_home.dart';

class AppState {

  // Authenticated user object
  late final Map<String,dynamic> _auth;

  // Get device info
  late final Map<String,dynamic> _device;

  // Get device info
  late final Map<String,dynamic> _home;

  // Initializa state
  AppState(this._auth,this._device,this._home);

  Map<String,dynamic> get auth => _auth;

  Map<String,dynamic> get device => _device;

  Map<String,dynamic> get home => _home;

  AppState.initialState() : 
    _auth = {
      "token": "",
    }, 
    _device = {
      "id"  :  "",
      "name":  ""
    },
    _home = {
      "tab": 0
    };
  

}

// Initialize application state reducer
AppState appReducer(AppState state, dynamic action) {
  // Check the type of action provided
  if( action is UpdateDevice){
    return AppState(state.auth,action.device,state.home);
  }
  if( action is UpdateAuth){
    return AppState(action.auth,state.device,state.home);
  } 
  if( action is UpdateHome){
    return AppState(state.auth,state.device,action.home);
  }    
  return state;
}