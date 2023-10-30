import 'package:data_cache_manager/data_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings_ecommerce/components/tabs/account.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/cart.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/categories.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/shop.tab.component.dart';
import 'package:markholdings_ecommerce/store/actions/auth.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/tab.action.store.dart';
import 'package:markholdings_ecommerce/store/actions/user.action.store.dart';
import 'package:markholdings_ecommerce/store/app.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

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

  Future<void> checkAuth() async{

    final cacheManager = Provider.of<DataCacheManager>(context,listen: false);
    final store        = Provider.of<Store>(context,listen: false);
    final auth         = await cacheManager.get('auth');

    if( auth != null ){
      store.dispatch(UpdateAuth((auth.value as Map<String,dynamic> )['token']));
      store.dispatch(UpdateUser((auth.value as Map<String,dynamic> )['user']));
    }
    
  }

  void _onItemTapped(int index) {
    final store = Provider.of<Store>(context,listen: false);
    setState(() {
      store.dispatch(UpdateTab(index));
    });
  }

  @override
  void initState(){
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StoreConnector<AppState,AppState>(
        builder: (context,AppState state){
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: SafeArea(
              child: _widgetChildren[state.tab]
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                  backgroundColor: Colors.blueAccent
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shop_2),
                  label: 'Shop',
                  backgroundColor: Colors.blueAccent
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                  backgroundColor: Colors.blueAccent
                ),              
                BottomNavigationBarItem(
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