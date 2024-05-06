import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  late Function callback;
  SignUpView({super.key,required this.callback,});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - ( MediaQuery.of(context).size.height * 0.1),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            "Register",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            "Create your account",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Padding(
            padding: EdgeInsets.only(top:10),
            child: TextFormField(
              // controller: _controllerUsername,
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
              // validator: (String? value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please enter username.";
              //   } else if (_boxAccounts.containsKey(value)) {
              //     return "Username is already registered.";
              //   }
                
              //   return null;
              // },
              // onEditingComplete: () => _focusNodeEmail.requestFocus(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: TextFormField(
              // controller: _controllerUsername,
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
              // validator: (String? value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please enter username.";
              //   } else if (_boxAccounts.containsKey(value)) {
              //     return "Username is already registered.";
              //   }
                
              //   return null;
              // },
              // onEditingComplete: () => _focusNodeEmail.requestFocus(),
            ),
          ),                     
          Padding(
            padding: EdgeInsets.only(top:10),
            child: TextFormField(
              // controller: _controllerEmail,
              // focusNode: _focusNodeEmail,
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
              // validator: (String? value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please enter email.";
              //   } else if (!(value.contains('@') && value.contains('.'))) {
              //     return "Invalid email";
              //   }
              //   return null;
              // },
              // onEditingComplete: () => _focusNodePassword.requestFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:10),
            child: TextFormField(
              // controller: _controllerPassword,
              // obscureText: _obscurePassword,
              // focusNode: _focusNodePassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.password_outlined),
                // suffixIcon: IconButton(
                //     onPressed: () {
                //       setState(() {
                //         _obscurePassword = !_obscurePassword;
                //       });
                //     },
                //     icon: _obscurePassword
                //         ? const Icon(Icons.visibility_outlined)
                //         : const Icon(Icons.visibility_off_outlined)),
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
                } else if (value.length < 8) {
                  return "Password must be at least 8 character.";
                }
                return null;
              },
              // onEditingComplete: () =>
              //     _focusNodeConfirmPassword.requestFocus(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:10),
            child: TextFormField(
              // controller: _controllerConFirmPassword,
              // obscureText: _obscurePassword,
              // focusNode: _focusNodeConfirmPassword,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: const Icon(Icons.password_outlined),
                // suffixIcon: IconButton(
                //     onPressed: () {
                //       setState(() {
                //         _obscurePassword = !_obscurePassword;
                //       });
                //     },
                //     icon: _obscurePassword
                //         ? const Icon(Icons.visibility_outlined)
                //         : const Icon(Icons.visibility_off_outlined)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // validator: (String? value) {
              //   if (value == null || value.isEmpty) {
              //     return "Please enter password.";
              //   } else if (value != _controllerPassword.text) {
              //     return "Password doesn't match.";
              //   }
              //   return null;
              // },
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
                    // if (_formKey.currentState?.validate() ?? false) {
                    //   _boxAccounts.put(
                    //     _controllerUsername.text,
                    //     _controllerConFirmPassword.text,
                    //   );
          
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       width: 200,
                    //       backgroundColor:
                    //           Theme.of(context).colorScheme.secondary,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       behavior: SnackBarBehavior.floating,
                    //       content: const Text("Registered Successfully"),
                    //     ),
                    //   );
          
                    //   _formKey.currentState?.reset();
          
                    //   Navigator.pop(context);
                    // }
                  },
                  child: const Text("Register"),
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
          ]
        )
      ),
    );
  }
}