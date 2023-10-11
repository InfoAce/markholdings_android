import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_android/states/app_state.dart';
import 'package:markholdings_android/views/components/login.dart';
import 'package:markholdings_android/views/components/signup.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  
  late final _tabController = TabController(length: 2, vsync: this);

  // Update tab index
  changeTab(value){
    setState(() {
      _tabController.index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(auth(context).auth);
    return StoreConnector<AppState,AppState>(
        builder: (context,AppState state){
          if( state.auth['user'].entries.isEmpty){
            return DefaultTabController(
              length: 2, 
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Login(callback: changeTab, deviceId: state.device['id']),
                  SignUp(callback: changeTab)
                ]
              )
            );
          } else if( !state.auth['user'].entries.isEmpty ){
            return const Text('AccountScreen'); 
          }
          return Container(
            child: const Text('Account')
          );
        }, 
        converter: (store) =>  store.state
      );
  }
}