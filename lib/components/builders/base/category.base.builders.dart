import 'package:flutter/material.dart';

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
    return InkWell(
          onTap: (){
            // DefaultTabController.of(context).animateTo(1);
            // Navigator.push(
            //   context, 
            //   MaterialPageRoute(
            //     builder: (context) => Home(categoryId: category['id']) )
            // );
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
                  image: Image.network(widget.category['image_url']).image,
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
                        scrollDirection: Axis.horizontal,
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
                                    label: Text("Products: $productsCount"),
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left:5.0),
                                  child: DefaultTextStyle(
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Rubik',
                                      color: Colors.white
                                    ),
                                    child: Badge(
                                      label: Text("Sub Categories: $productCategoriesCount"),
                                      backgroundColor: Colors.blueAccent,
                                    ),
                                  ),
                                ),
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
                        child: Text(widget.category['name'])
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