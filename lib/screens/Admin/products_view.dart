// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shoes_business/Methods/product_method.dart';
import 'package:shoes_business/components/my_button.dart';


class ProductsView extends StatefulWidget {
  final String uniqueId;
  const ProductsView({super.key, required this.uniqueId});
  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final cloudinary = CloudinaryPublic('duoqdpodl', 'Mudi_upload');
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Access the product-Category collection by ID
    final products = _firestore
        .collection('Product_Category')
        .doc(widget.uniqueId);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 225, 225),
      appBar: AppBar(
        title: const Text('Update Products'),
        backgroundColor: const Color.fromARGB(255, 201, 225, 225),
       
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: products.collection('Products').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final productList = snapshot.data!.docs;

            if (productList.isEmpty) {
              return const Center(child: Text('No Products uploaded yet.'));
            }

            return MasonryGridView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
              children: [
                const Text(
                  "Enjoy Your Shopping With Mudi",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Color.fromARGB(255, 12, 169, 4),
                  ),
                ),
                for (var eachProduct in productList)
                  GestureDetector(
                    onTap:
                        () { 
                        //   Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) =>
                        //             DetailsProduct(eachproduct: eachProduct),
                        //   ),
                        // );
                        },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 1.5,
                        ),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              eachProduct['imageUrl'],
                              height: 200,
                              width: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            eachProduct['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Click for Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Colors.green,
                                  ),
                                ),

                                Container(
                                  width: 35,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 26, 48, 96),
                                  ),
                                  child: const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: MyButton(
        color: const Color.fromARGB(255, 0, 97, 15),
        
        onPressed: () {
          ProductMethod.addProduct(context, widget.uniqueId);
        },
        text: "+ Add Product ",
      ),
    );
  }
}
