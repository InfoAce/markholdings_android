import 'dart:convert';
import 'dart:ffi';

import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_9/components/tabs/account.tab.component.dart';
import 'package:markholdings_9/components/tabs/cart.tab.component.dart';
import 'package:markholdings_9/components/tabs/categories.tab.component.dart';
import 'package:markholdings_9/components/tabs/shop.tab.component.dart';
import 'package:markholdings_9/store/actions/auth.action.store.dart';
import 'package:markholdings_9/store/actions/cart.action.store.dart';
import 'package:markholdings_9/store/actions/tab.action.store.dart';
import 'package:markholdings_9/store/actions/user.action.store.dart';
import 'package:markholdings_9/store/app.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<StatefulWidget> _widgetChildren = const [
    CategoriesTab(),
    ShopTab(),
    CartTab(),
    AccountTab()
  ];

  DataCacheManager? cacheManager;
  Store? store;

  Future<void> checkAuth() async{

    CachedData? authStore    = await cacheManager?.get('auth'); 
    Map<String,dynamic> auth = authStore != null ? jsonDecode(authStore.value.toString()) : {};

    if( auth.containsKey('user') && auth['user']['email_verified_at'] == null ){

      if(!mounted) return;

      Navigator.pushNamed(context, 'verification');

    }

    if( auth.isNotEmpty && auth.containsKey('token') ){
            
      store?.dispatch(UpdateAuth(auth['token']));
      
      store?.dispatch(UpdateUser(auth['user']));

    }
    
  }

  Future<void> checkCart() async{
    CachedData? cartStore = await cacheManager?.get('shopping_cart');
    if( cartStore != null ) store?.dispatch(UpdateCartItems((cartStore.value as List).length )); 
  }

  void _onItemTapped(int index) {
    setState(() {
      store?.dispatch(UpdateTab(index));
    });
  }

  @override
  void initState(){
    super.initState();
    cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    store        = Provider.of<Store>(context,listen: false);
    checkAuth();
    checkCart();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StoreConnector<AppState,AppState>(
        builder: (context,AppState state){
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: _widgetChildren[state.tab]
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                  backgroundColor: Colors.blueAccent
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shop_2),
                  label: 'Shop',
                  backgroundColor: Colors.blueAccent
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                    badgeContent: Text(state.cartItems.toString()),
                    badgeAnimation: const badges.BadgeAnimation.rotation(
                      animationDuration: Duration(seconds: 1),
                      colorChangeAnimationDuration: Duration(seconds: 1),
                      loopAnimation: false,
                      curve: Curves.fastOutSlowIn,
                      colorChangeAnimationCurve: Curves.easeInCubic,
                    ),    
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.white,
                      elevation: 2,
                    ), 
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: 'Cart',
                  backgroundColor: Colors.blueAccent
                ),              
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                  backgroundColor: Colors.blueAccent
                ),
              ],
              currentIndex: state.tab,
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
            )        
          );
        },
        converter: (store) =>  store.state
      ),
    );
  }
}