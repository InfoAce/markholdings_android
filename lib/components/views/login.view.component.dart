import 'dart:async';
import 'dart:convert';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:android_app/models/login.model.dart';
import 'package:android_app/services/api.service.dart';
import 'package:android_app/store/actions/auth.action.store.dart';
import 'package:android_app/store/actions/user.action.store.dart';
import 'package:android_app/validations/login.validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginView extends StatefulWidget {
  late Function callback;

  LoginView({super.key,required this.callback});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final FocusNode _focusNodePassword              = FocusNode();
  final TextEditingController _controllerEmail    = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey                                  = GlobalKey<FormState>();
  bool _obscurePassword                           = true;
  bool _loading                                   = false;
  final baseUrl                                   = dotenv.env['BASE_URL'];
  Store ? store;
  DataCacheManager ? cacheManager;

  late Uri authorizeUrl;
 
  LoginModel form = LoginModel();

  @override
  void initState(){
    super.initState();
    store        = Provider.of<Store>(context,listen: false);
    cacheManager = Provider.of<DataCacheManager>(context,listen: false);
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Text(
              'Welcome Back',
              style: GoogleFonts.poppins(
                color: Colors.blueAccent,
                fontSize: 30
              )
            ),   
            Text(
              'Enter valid credentials.',
              style: GoogleFonts.poppins(
                color: Colors.blueAccent,
                fontSize: 15
              )
            ),                      
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: TextFormField(
                controller: _controllerEmail,
                // keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address.";
                  } 
                  return null;
                },                  
                onChanged: (text) {
                    setState(() {
                      form.email = text;
                    });
                },            
              ),
            ),   
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: TextFormField(
                controller:  _controllerPassword,
                focusNode:   _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  } 
                  return null;
                },                  
                onChanged: (text) {
                  setState(() {
                    form.password = text;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? true && _loading == false) {
                        
                        setState(() { 
                          form.client_id     = store?.state.env['OAUTH_ID'];
                          form.client_secret = store?.state.env['OAUTH_SECRET'];
                          _loading = true; 
                        });

                        login();
                        
                      }                          
                    },
                    child: _loading ? 
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ) 
                      : const Text("Login", style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          widget.callback(1);
                        },
                        child: const Text("Signup",style: TextStyle(color:Colors.blueAccent)),
                      ),
                    ],
                  ),
                ],
              ),
            ),                                                           
          ]
        ),
      ),
    );
  }

  showMessage(String message,Color color){
    setState(() => _loading = false ); 

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

  Future<dynamic> login() async {

    try{ 
        
      setState(() => _loading = true ); 
      
      Response response        = await Provider.of<ApiService>(context,listen: false).post(Uri.parse('/auth/login'.toString()),body: jsonEncode(form.toMap()));                     
      Map<String,dynamic> data = jsonDecode(response.body);

      if( response.statusCode == 200 ){

        store?.dispatch(UpdateAuth(data['auth']));  
        store?.dispatch(UpdateUser(data['user']));   

        await cacheManager?.add('auth',jsonEncode({ 'user': data['user'], 'token': data['auth'] }));  
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
