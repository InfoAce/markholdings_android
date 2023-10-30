import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryBase extends StatefulWidget {
  CategoryBase({super.key,required this.category});

  final Map<String,dynamic> category;

  @override
  State<CategoryBase> createState() => _CategoryBaseState();
}

class _CategoryBaseState extends State<CategoryBase> {

  late int productsCount;
  late int productCategoriesCount;

  @override
  void initState(){
    productsCount          = widget.category['products_count'];
    productCategoriesCount = widget.category['product_categories_count'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  MediaQuery.of(context).size.height * 0.2,
      width:   MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
            padding: EdgeInsets.all(10.0),
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
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [                  
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: Colors.white,
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
                  iconSize: MediaQuery.of(context).size.width * 0.07,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    // final store   = Provider.of<Store>(context,listen: false);   
                    // store.dispatch(ViewProduct(widget.product));                    
                  },
                ),                                            
              ],
            ),
          ),                                                                                                                                                                                                                                                                                        
        ]
      )
    );
  }
}