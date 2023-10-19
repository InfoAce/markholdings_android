import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:markholdings_ecommerce/models/login.model.dart';
import 'package:markholdings_ecommerce/models/user.model.dart';
import 'package:markholdings_ecommerce/services/api.service.dart';
import 'package:markholdings_ecommerce/store/actions/user.action.store.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';
import 'package:markholdings_ecommerce/validations/authorize.validation.dart';
import 'package:markholdings_ecommerce/validations/login.validation.dart';
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
  bool _authorize                                 = false;

  late Uri authorizeUrl;
 
  LoginModel form = LoginModel();

  @override
  void initState(){
    setState(() {
      form.deviceId = widget.deviceInfo['id'];
    });
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
        child: _authorize ? authorizeWebView() : loginWidget(),
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
            padding: EdgeInsets.only(top: 30),
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

  Widget authorizeWebView(){
  final webViewController = WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onProgress: (int progress) {
                            // print the loading progress to the console
                            // you can use this value to show a progress bar if you want
                            debugPrint("Loading: $progress%");
                          },
                          onPageStarted: (String url) {},
                          onPageFinished: (String url) {},
                          onWebResourceError: (WebResourceError error) {},
                          // onNavigationRequest: (NavigationRequest request) {
                          //   return NavigationDecision.navigate;
                          // },
                        ),
                      )
                      ..loadRequest(authorizeUrl);    
    return Expanded(
      child: WebViewWidget(
        controller: webViewController
      )
    );
  }

  Future<void> authorize(data,context) async{
    final userId  = data.token['accessToken']['tokenable_id'];
    final device  = base64.encode(utf8.encode(jsonEncode(widget.deviceInfo)));
    final store   = Provider.of<Store>(context,listen: false);       
    setState(() {
      authorizeUrl = Uri.parse("$baseUrl/authorize/$device/$userId".toString());
      _authorize   = true;
    });
    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
      backgroundColor: Colors.blueAccent,
      content: Row(
        children: [
          Icon(
            color: Colors.white,
            Icons.info
          ),
          Flexible(child: Text('Authorize this device.'))
        ],
      ),
    ));  
    if( _authorize ){
      final api   = Provider.of<ApiService>(context,listen: false);
      final Timer timer = Timer.periodic(const Duration(seconds:2), (timer) async{
        final deviceId = widget.deviceInfo['id'];
        final response = await api.get(Uri.parse('authorize/device/$deviceId'.toString()));
        switch(response.statusCode){
          case 200:
            AuthorizationValidation authorize = AuthorizationValidation.fromJson(jsonDecode(response.body));  
            UserModel().create(email: authorize.user['email'], token: data.token['plainTextToken'], blocked: authorize.device['blocked']);  
            store.dispatch(UpdateUser(authorize.user));
            setState(() {
              _authorize = false;
              timer.cancel();
            });   
          break;
        }

      });
    }
  }

  Future<dynamic> login(context) async { 
    setState(() => _loading = true ); 
    final response = await Provider.of<ApiService>(context,listen: false)
                                   .post(
                                      Uri.parse('/auth/login'.toString()),
                                      body: {
                                        "email":    form.email,
                                        "password": form.password,
                                        "device":   widget.deviceInfo['id']
                                      }
                                   );
    switch(response.statusCode){
      case 200:
        LoginValidation data = LoginValidation.fromJson(jsonDecode(response.body));
        authorize(data,context);
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
      case 404:
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