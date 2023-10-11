import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_android/models/login_form.dart';
import 'package:markholdings_android/services/api.dart';
import 'package:markholdings_android/states/actions/update_auth.dart';
import 'package:markholdings_android/states/app_state.dart';
import 'package:markholdings_android/views/validation/login_validation.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  late Function callback;
  late String deviceId;
  
  Login({super.key, required this.callback, required this.deviceId });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _focusNodePassword              = FocusNode();
  final TextEditingController _controllerEmail    = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword                           = true;
  bool _loading                                   = false;
  
  LoginForm form = LoginForm();
  late ApiService api;


  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    form.deviceId = widget.deviceId;
    api           = Provider.of<ApiService>(context);

    return Scaffold(
      body: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 150),
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),  
                const SizedBox(height: 10),
                Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),   
                const SizedBox(height: 60),       
                TextFormField(
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
                const SizedBox(height: 10),
                TextFormField(
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
                const SizedBox(height: 60),    
                Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      _loading = true;
                      if( form.email.isNotEmpty && form.password.isNotEmpty ){
                        api.post(
                            Uri.parse('/auth/login'.toString()),
                            body: {
                              "email":    form.email,
                              "password": form.password,
                              "device":   form.deviceId
                            })
                            .then((value){
                              print( LoginValidation.fromJson(jsonDecode(value.body)).token);
                              // return LoginValidation.fromJson(jsonDecode(value.body));
                            })
                            .catchError((e) {
                              print(e);
                            });                  
                          // StoreProvider.of<AppState>(context)
                          //     .dispatch(UpdateAuth(auth['token']));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.blueAccent,
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
                    child: const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          widget.callback(1);
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  ),
                ],
                ),                                                           
              ]
            )
          ),
    );
  }

}