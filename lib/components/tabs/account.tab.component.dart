import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:android_app/components/views/login.view.component.dart';
import 'package:android_app/components/views/profile.view.component.dart';
import 'package:android_app/components/views/signup.view.component.dart';
import 'package:android_app/store/app.store.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> with SingleTickerProviderStateMixin{
  late final _tabController = TabController(length: 2, vsync: this);

  // Update tab index
  changeTab(value){
    setState(() {
      _tabController.index = value;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoreConnector<AppState,AppState>(
        builder: (context,AppState state){
      
          if( state.auth.isEmpty){
            return DefaultTabController(
              length: 2, 
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  LoginView(callback: changeTab),
                  SignUpView(callback: changeTab)
                ]
              )
            );
          } 
          
          return  ProfileView(); 
      
        }, 
        
        converter: (store) =>  store.state
      ),
    );
  }
}