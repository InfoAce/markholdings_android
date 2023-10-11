import 'package:flutter/material.dart';
import 'package:markholdings_android/views/show/account_screen.dart';
import 'package:markholdings_android/views/show/categories_screen.dart';
import 'package:markholdings_android/views/show/favourites_screen.dart';
import 'package:markholdings_android/views/show/shop_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>{

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: TabBarView(
              children: <Widget>[
                CategoriesScreen(),
                ShopScreen(),
                FavouritesScreens(),
                AccountScreen()
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: TabBar(
              indicator:  BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black54
              ),
              labelColor:           Colors.blueAccent,
              unselectedLabelColor: Colors.white,
              indicatorSize:        TabBarIndicatorSize.tab,
              indicatorPadding:     const EdgeInsets.all(5.0),
              tabs:const <Widget>[
                Tab(
                  text: "Home",
                  icon: Icon(Icons.home_rounded)
                ),
                Tab(
                  text: "Shop",
                  icon: Icon(Icons.shop_2)
                ),
                Tab(
                  text: "Cart",
                  icon: Icon(Icons.shopping_cart)
                ),
                Tab(
                  text: "Account",
                  icon: Icon(Icons.person)
                ),
              ]
            )
          ),
        ),
      )
    );
  }

}
