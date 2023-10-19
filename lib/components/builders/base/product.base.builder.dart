import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/store/actions/product.action.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

class ProductBase extends StatefulWidget {
  ProductBase({super.key,required this.product});

  late Map<String,dynamic> product;
  @override
  State<ProductBase> createState() => _ProductBaseState();
}

class _ProductBaseState extends State<ProductBase> {
  late String category;
  late int productCategoriesCount;

  @override
  void initState(){
    category = widget.product['product_category']['name'];
    // productCategoriesCount = widget.category['product_categories_count'];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: (){
            final store   = Provider.of<Store>(context,listen: false);   
            store.dispatch(ViewProduct(widget.product));
          },
          child:  Container(
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                image: DecorationImage(
                  image: Image.network(widget.product['image_url']).image,
                  fit: BoxFit.cover,
              ),
            ),
            child:Stack(
              children: <Widget>[              
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.6),
                ),
                widget.product['tag'] != null ?
                  DefaultTextStyle(
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Rubik',
                      color: Colors.white
                    ),
                    child: Badge(
                      label: Text(widget.product['tag']['name']),
                      backgroundColor: Colors.blueAccent,
                    ),
                  ) 
                : const Text(''),  
                Container(
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withAlpha(5),
                        Colors.black12,
                        Colors.black45
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                                DefaultTextStyle(
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Rubik',
                                    color: Colors.white
                                  ),
                                  child: Badge(
                                    label: Text("Category: $category"),
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(left:5.0),
                                //   child: DefaultTextStyle(
                                //     textAlign: TextAlign.start,
                                //     style: const TextStyle(
                                //       fontSize: 25,
                                //       fontFamily: 'Rubik',
                                //       color: Colors.white
                                //     ),
                                //     child: Badge(
                                //       label: Text("Sub Categories: $productCategoriesCount"),
                                //       backgroundColor: Colors.blueAccent,
                                //     ),
                                //   ),
                                // ),
                            ],
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Rubik',
                          color: Colors.white
                        ),
                        child: Text(widget.product['name'])
                      ),
                      
                    ]
                  ),
                ),
              ],
            )                  
          ),
        );
  }
}