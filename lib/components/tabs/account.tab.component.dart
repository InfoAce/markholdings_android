import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings/components/views/login.view.component.dart';
import 'package:markholdings/components/views/profile.view.component.dart';
import 'package:markholdings/components/views/signup.view.component.dart';
import 'package:markholdings/store/app.store.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
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