import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markholdings/store/actions/category.action.store.dart';
import 'package:markholdings/store/actions/tab.action.store.dart';
import 'package:redux/redux.dart';
import 'package:provider/provider.dart';

class CategoryBase extends StatefulWidget {
  const CategoryBase({super.key,required this.category});

  final Map<String,dynamic> category;

  @override
  State<CategoryBase> createState() => _CategoryBaseState();
}

class _CategoryBaseState extends State<CategoryBase> {

  late int productsCount;
  late int productCategoriesCount;

  Store? store;
  
  @override
  void initState(){
    productsCount          = widget.category['products_count'];
    productCategoriesCount = widget.category['product_categories_count'];
  }
  void _onItemTapped() {
    setState(() {
      store?.dispatch(UpdateTab(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height:  MediaQuery.of(context).size.height * 0.2,
        width:   MediaQuery.of(context).size.width,
        margin:  const EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.4),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            image: DecorationImage(
              image: Image.network(widget.category['image_url']).image,
              fit: BoxFit.cover,
            ),
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.6),
            ),  
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category['name'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05
                    )
                  ),
                  Text(
                    "Products: $productsCount",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.03
                    )
                  )                                                                                                
                ]
              ),
            ),                                                                                                                                                                                                                                                                                       
          ]
        )
      ),
      onTap: () {
        final store   = Provider.of<Store>(context,listen: false);   
        store.dispatch(UpdateTab(1));                    
        store.dispatch(UpdateCategory({ "id": widget.category['id'], "name": widget.category['name'] }));   
      },
    );
  }
}