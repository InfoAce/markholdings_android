import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:markholdings/components/views/product.view.component.dart';
import 'package:markholdings/components/views/products.view.component.dart';
import 'package:markholdings/store/app.store.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: StoreConnector<AppState,AppState>(
          builder: (context,AppState state){
            if( state.product.isNotEmpty ){
              return ProductView(product: state.product);
            }
            return const ProductsView();
          }, 
          converter: (store) =>  store.state
        ),
    );
  }
}