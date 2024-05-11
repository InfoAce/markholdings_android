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
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginView extends StatefulWidget {
  late Function callback;
  late Map<String, dynamic> deviceInfo;

  LoginView({super.key,required this.callback, required this.deviceInfo});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final FocusNode _focusNodePassword              = FocusNode();
  final TextEditingController _controllerEmail    = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword                           = true;
  bool _loading                                   = false;
  final baseUrl                                   = dotenv.env['BASE_URL'];

  late Uri authorizeUrl;
 
  LoginModel form = LoginModel();

  @override
  void initState(){
    super.initState();
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
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - ( MediaQuery.of(context).size.height * 0.15),
        padding: EdgeInsets.all(15.0),
        child: loginWidget(),
      ),
    );
  }

  Widget loginWidget(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome back",
            style: Theme.of(context).textTheme.headlineLarge,
          ),  
          Text(
            "Login to your account",
            style: Theme.of(context).textTheme.bodyMedium,
          ),   
          Padding(
            padding: EdgeInsets.only(top:10),
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
              onChanged: (text) {
                  setState(() {
                    form.email = text;
                  });
              },            
            ),
          ),   
          Padding(
            padding: EdgeInsets.only(top:10),
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
                    backgroundColor: form.email.isEmpty || form.password.isEmpty || _loading ? Colors.grey[400] : Colors.blueAccent,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if( form.email.isNotEmpty && form.password.isNotEmpty ){   
                      if( !_loading ){                                                    
                        login(context); 
                      }                       
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.amber,
                        content: Row(
                          children: [
                            Icon(
                              color: Colors.white,
                              Icons.info
                            ),
                            Text('The email address and password fields are required.')
                          ],
                        ),
                      ));
                    }
                  },
                  child: _loading ? 
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ) 
                    : const Text("Login"),
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
    );
  }
  
  Future<dynamic> login(context) async { 
    setState(() => _loading = true ); 
    final store        = Provider.of<Store>(context,listen: false);
    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final response     = await Provider.of<ApiService>(context,listen: false)
                                       .post(
                                          Uri.parse('/auth/login'.toString()),
                                          body: jsonEncode({
                                            "email":         form.email,
                                            "password":      form.password,
                                            "client_id":     store.state.env['OAUTH_ID'],
                                            "client_secret": store.state.env['OAUTH_SECRET'],
                                          })
                                        );
                          
    switch(response.statusCode){
      case 200:
        setState(() => _loading = false ); 
        LoginValidation data = LoginValidation.fromJson(jsonDecode(response.body));
        store.dispatch(UpdateAuth(data.auth));  
        store.dispatch(UpdateUser(data.user));         
        await cacheManager.add('auth',jsonEncode({ 'user': data.user, 'token': data.auth }));  
      break;
      case 401:
        setState(() => _loading = false ); 
        Map<String,dynamic> data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: Colors.amber,
          content: Row(
            children: [
              const Icon(
                color: Colors.white,
                Icons.info
              ),
              Flexible(child: Text(data['message']))
            ],
          ),
        ));      
      break;
      case 422:
        setState(() => _loading = false ); 
        Map<String,dynamic> data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Row(
            children: [
              const Icon(
                color: Colors.white,
                Icons.info
              ),
              Flexible(child: Text(data['message']))
            ],
          ),
        ));      
      break;      
      case 404:
      case 500:
        setState(() => _loading = false ); 
        Map<String,dynamic> data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: Colors.amber,
          content: Row(
            children: [
              const Icon(
                color: Colors.white,
                Icons.info
              ),
              Flexible(child: Text(data['message']))
            ],
          ),
        ));                              
      break;
    }                             
  } 
}
