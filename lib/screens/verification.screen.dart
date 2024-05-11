import 'dart:async';
import 'dart:convert';
import 'package:android_app/services/api.service.dart';
import 'package:android_app/store/actions/tab.action.store.dart';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  DataCacheManager? cacheManager;
  Timer? _timer;
  Store? store;

  bool _loader             = false;
  bool _verificationLoader = false;
  int _start               = 15;

  void startTimer() {

    Duration oneSec = const Duration(seconds: 1);
    
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        
        if (_start == 0) {
          setState(() {_timer?.cancel(); });
        } 

        if(_start != 0){
          setState(() {_start--; });
        }

      },
    );

  }

  @override
  void initState() {
    super.initState();
    cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    store        = Provider.of<Store>(context,listen: false);

  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20.0),
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _verificationLoader ? 
                  const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,                            
                    ),
                  ) : 
                const Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Verification Code",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  "You are almost there. Please check your mail for a verification sent to you.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                VerificationCode(
                  textStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
                  keyboardType: TextInputType.text,
                  underlineColor: Colors.white, // If this is null it will use primaryColor: Colors.red from Theme
                  length: 4,
                  cursorColor: Colors.white, // If this is null it will default to the ambient
                  clearAll: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Text(
                          'Clear all',
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left : 10),
                          child: ElevatedButton(
                            onPressed: () {
                              resendCode();
                            }, 
                            child: _loader ? 
                              const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,                            
                                ),
                              ) : 
                              Text(
                                _timer != null && _timer!.isActive ? _start.toString() : 'Resend Code',
                                style: const TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                              )
                          ),
                        )                                         
                      ],
                    ),
                  ),
                  onCompleted: (String value) {
                    codeConfirmation(value);
                  },
                  onEditing: (bool value) {
                    // setState(() {
                    //   _onEditing = value;
                    // });
                    // if (!_onEditing) FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showMessage(String message,Color color){
    setState(() => _loader = false ); 
    setState(() { _verificationLoader = false; });
    if(mounted){
      ScaffoldMessenger.of(super.context).showSnackBar( SnackBar(
        backgroundColor: color,
        content: Row(
          children: [
            const Icon(
              color: Colors.white,
              Icons.info
            ),
            Flexible(child: Text(message, style: const TextStyle(color: Colors.white),))
          ],
        ),
      ));          
    }
  }

  Future<void> codeConfirmation(String code) async {

    try {

      Map<String,dynamic> auth = jsonDecode((await cacheManager?.get('auth'))!.value.toString()) ?? {};
      Map<String,dynamic> user = auth['user'];
      String id                = user['id'];

      if( code != user['device_code'] ){
        showMessage(
          'Verification code is not valid.',
          Colors.amber
        );
        return;
      } 

      if(!mounted) return;
                                          
      setState(() { _verificationLoader = true; });
                                                  
      Response response = await Provider.of<ApiService>(super.context,listen: false).put(Uri.parse('/auth/$id/validate'.toString()));

      if( response.statusCode == 200 ){

        showMessage(
          'Account is successfully verified.',
          Colors.green
        );
        
        await cacheManager?.removeByKey('auth');  
        
        if(!mounted) return;
        
        Future.delayed(const Duration(seconds: 3),() {
          setState(() { store?.dispatch(UpdateTab(3)); });
          Navigator.pushNamed(context, 'home');
        });

      }    

    } catch (e) { 
      print(e);
      showMessage(
        'Internal Server Error. Please report this to the administrator.',
        Colors.red
      );
    
    }

  }

  Future<void> resendCode() async {
      
    if( _loader ) return;

    startTimer();

    setState(() { _loader = true; });
    
    try {

      Map<String,dynamic> auth = jsonDecode((await cacheManager?.get('auth'))!.value.toString()) ?? {};
      String id                = auth['user']['id'];
      
      if(!mounted) return;

      Response response        = await Provider.of<ApiService>(super.context,listen: false).put(Uri.parse('/auth/resend/$id/code'.toString()));

      Map<String,dynamic> data = jsonDecode(response.body);

      if( response.statusCode == 200 ){

        showMessage(
          'The code has been sent.',
          Colors.green
        );
        
        await cacheManager?.add('auth',jsonEncode({ 'user': data['user'] }));  

      }

      if( response.statusCode == 422 ){

        showMessage(
          data['message'],
          Colors.amber
        );
        
      }

      if( response.statusCode == 500 ){

        showMessage(
          'Internal Server Error. Please contact the server administrator.',
          Colors.red
        );
        
      }      
      

    } catch(error) {
      
      showMessage(
        'Internal Server Error. Please report this to the administrator.',
        Colors.red
      );
    
    }

  }

}