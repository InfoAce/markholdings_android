import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_ecommerce/components/views/login.view.component.dart';
import 'package:markholdings_ecommerce/components/views/profile.view.component.dart';
import 'package:markholdings_ecommerce/components/views/signup.view.component.dart';
// import 'package:markholdings_ecommerce/models/user.model.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';

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
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StoreConnector<AppState,AppState>(
          builder: (context,AppState state){
            if( state.user.isEmpty){
              return DefaultTabController(
                length: 2, 
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    LoginView(callback: changeTab, deviceInfo: state.device),
                    SignUpView(callback: changeTab)
                  ]
                )
              );
            } else if( state.user.isNotEmpty ){
              return ProfileView(); 
            }
            return Container(
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  )
                ]
              ),
            );
          }, 
          converter: (store) =>  store.state
        ),
    );
  }
}