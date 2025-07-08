import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_business/Customers/Cart/product.dart';

class CProductView extends StatefulWidget {
  final String uniqueId;
  const CProductView({super.key,required this.uniqueId});

  @override
  State<CProductView> createState() => _CProductViewState();
}

class _CProductViewState extends State<CProductView> {
  @override
  Widget build(BuildContext context) {
    final products = FirebaseFirestore.instance
        .collection('Product_Category')
        .doc(widget.uniqueId);
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 159, 6),
          ),
        ),
       
        actions: [
          IconButton(
            onPressed: () {
             
            },
            icon: const Icon(
              Icons.shopping_cart,
              size: 35,
              color: Color.fromARGB(255, 0, 141, 21),
            ),
          ),
        ],
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
                  "Enjoy Your Shopping With Mudi😊",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(255, 0, 159, 6),
                  ),
                ),
                for (var eachProduct in productList)
                  Product(eachProduct: eachProduct, uniqueId: widget.uniqueId,),
              ],
            );
          },
        ),
      ),
    );
  }
}