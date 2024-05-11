import 'dart:convert';

import 'package:android_app/models/signup.model.dart';
import 'package:android_app/services/api.service.dart';
import 'package:android_app/store/actions/auth.action.store.dart';
import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  late Function callback;
  SignUpView({super.key,required this.callback,});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final List<Map<String,String>> _accountTypes = [
    { "label": "Corporate Account", "value": "corporate" },
    { "label": "Personal Account",  "value": "personal"  }
  ];
  final FocusNode _focusNodeFirstName                    = FocusNode();
  final FocusNode _focusNodeLastName                     = FocusNode();
  final FocusNode _focusNodeEmail                        = FocusNode();
  final FocusNode _focusNodeAccountType                  = FocusNode();
  final FocusNode _focusNodePassword                     = FocusNode();
  final FocusNode _focusNodeConfirmPassword              = FocusNode();
  final TextEditingController _controllerFirstName       = TextEditingController();
  final TextEditingController _controllerLastName        = TextEditingController();
  final TextEditingController _controllerEmail           = TextEditingController();
  final TextEditingController _controllerAccountType     = TextEditingController();
  final TextEditingController _controllerPassword        = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  final _formKey                                         = GlobalKey<FormState>();
  bool _loader                                           = false;
  bool _obscurePassword                                  = true;
  bool _obscureConfirmPassword                           = true;
  SignupModel form                                       = SignupModel();
  DataCacheManager? cacheManager;
  
  @override
  void initState() {
    cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeFirstName.dispose();
    _focusNodeLastName.dispose();
    _focusNodeEmail.dispose();
    _focusNodeAccountType.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerEmail.dispose();
    _controllerAccountType.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - ( MediaQuery.of(context).size.height * 0.1),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,            
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(100.0)),
                ),                
                // decoration: BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Create your account",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    )
                  ],
                )
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: TextFormField(
                        controller: _controllerFirstName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter first name.";
                          }                 
                          return null;
                        },
                        onChanged: (text) {
                            setState(() {
                              form.first_name = text;
                            });
                        },                  
                        onEditingComplete: () => _focusNodeFirstName.requestFocus(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: TextFormField(
                        controller: _controllerLastName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter last name.";
                          } 
                          return null;
                        },
                        onChanged: (text) {
                            setState(() {
                              form.last_name = text;
                            });
                        },               
                        onEditingComplete: () => _focusNodeLastName.requestFocus(),
                      ),
                    ),                     
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: TextFormField(
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email.";
                          }
                          if (!(value.contains('@') && value.contains('.'))) {
                            return "Invalid email";
                          }
                          return null;
                        },
                        onChanged: (text) {
                            setState(() {
                              form.email = text;
                            });
                        },                   
                        onEditingComplete: () => _focusNodeEmail.requestFocus(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: DropdownButtonFormField(              
                        focusNode:   _focusNodeAccountType,
                        decoration: InputDecoration(
                          labelText: "Account Type",
                          focusColor: Colors.blueAccent,
                          prefixIcon: const Icon(Icons.group_add),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          isDense: true
                        ),
                        items: _accountTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type['value'],
                            child: Text(
                              type['label'].toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(), 
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter the account type.";
                          }
                          return null;
                        },                  
                        onChanged: (value) {
                          setState(() {
                            form.account_type = value.toString();
                          });
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: TextFormField(
                        controller:  _controllerPassword,
                        obscureText: _obscurePassword,
                        focusNode:   _focusNodePassword,
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
                          if (value.length < 8) {
                            return "Password must be at least 8 character.";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            form.password = value.toString();
                          });
                        },
                        onEditingComplete: () =>_focusNodePassword.requestFocus(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10),
                      child: TextFormField(
                        controller: _controllerConfirmPassword,
                        obscureText: _obscurePassword,
                        focusNode: _focusNodeConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
                          if (value != _controllerPassword.text) {
                            return "Password doesn't match.";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            form.password_confirmation = value.toString();
                          });
                        },
                        onEditingComplete: () =>_focusNodeConfirmPassword.requestFocus(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:30),
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
                              if (_formKey.currentState?.validate() ?? true && _loader == false) {
                                setState(() { _loader = true; });
                                register();
                              }

                            },
                            child: _loader ? 
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ): 
                              const Text("Register", style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () => setState(() {
                                  widget.callback(0);                  
                                }),
                                child: const Text("login",style: TextStyle(color:Colors.blueAccent)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),                                                                    
                  ],
                ),
              )
            ]
          ),
        )
      ),
    );
  }

  showMessage(String message,Color color){
    setState(() => _loader = false ); 

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

  Future<void> register() async {

    try {
      
      Response response = await Provider.of<ApiService>(context,listen: false).post(Uri.parse('/auth/signup'.toString()),body: jsonEncode(form.toMap()));

      Map<String,dynamic> data = jsonDecode(response.body);

      if( response.statusCode == 200 ){

        showMessage(
          'Registration successfull. Please check your mail for the verification code to activate your account.',
          Colors.green
        );

        await cacheManager?.add('auth',jsonEncode({ 'user': data['user'] }));  
        
        Future.delayed(const Duration(seconds: 2),() {
          Navigator.pushNamed(context, 'verification');
        });
        
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