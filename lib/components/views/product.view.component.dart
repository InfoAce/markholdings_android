import 'package:flutter/material.dart';
import 'package:markholdings_ecommerce/store/actions/product.action.store.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductView extends StatefulWidget {
  ProductView({super.key,required this.product});

  final Map<String,dynamic> product;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  @override
  Widget build(BuildContext context) {
    int price = widget.product["price"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: TextButton(
            style: const ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),           
            onPressed: () {
              final store   = Provider.of<Store>(context,listen: false);   
              store.dispatch(ViewProduct({}));                  
            }, 
            child: const Icon(Icons.chevron_left),
          ),
      ),
      body:  Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(0.0),
            color: Colors.grey[200],
            child: Image.network(widget.product['image_url']),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration:  const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['product_category']['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "$price",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor consectetur tortor vitae interdum.',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Similar This',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // SizedBox(
                        //   height: 110,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: smProducts.length,
                        //     itemBuilder: (context, index) => Container(
                        //       margin: const EdgeInsets.only(right: 6),
                        //       width: 110,
                        //       height: 110,
                        //       decoration: BoxDecoration(
                        //         color: AppColors.kSmProductBgColor,
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       child: Center(
                        //         child: Image(
                        //           height: 70,
                        //           image: AssetImage(smProducts[index].image),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),          
        ]
      )
    );
    // return SingleChildScrollView(
    //   child: StickyHeader(
    //     callback: (stuckAmount) {
    //       print(stuckAmount);
    //     },
    //     header: Container(
    //       width: MediaQuery.of(context).size.width,
    //       color: Colors.blueAccent,
    //       child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             ElevatedButton(
    //               style: const ButtonStyle(
    //                 padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
    //                 iconColor: MaterialStatePropertyAll<Color>(Colors.white),
    //               ),
    //               onPressed: () {
    //                 clickButton(context);
    //                 print('here');
    //                 // final store   = Provider.of<Store>(context,listen: false);   
    //                 // store.dispatch(ViewProduct({}));                  
    //               }, 
    //               child: Text('Select'),
    //             )
    //           ],
    //         )
    //     ),
    //     content: Container(
    //       color: Colors.grey[200],
    //       child: Padding(
    //         padding: const EdgeInsets.all(5.0),
    //         child: Column(
    //           children: [

    //           ],
    //         )
    //     ),
    //   )
    // )
    // );
  }

}