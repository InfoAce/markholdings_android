import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/components/tabs/account.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/cart.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/categories.tab.component.dart';
import 'package:markholdings_ecommerce/components/tabs/shop.tab.component.dart';
import 'package:markholdings_ecommerce/database/init.database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  final List<StatefulWidget> _widgetChildren = const [
    CategoriesTab(),
    ShopTab(),
    CartTab(),
    AccountTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;    
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: _widgetChildren[_selectedIndex]
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        )        
      ),
    );
  }
}