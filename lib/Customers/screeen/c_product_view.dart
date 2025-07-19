import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_business/Customers/Card%20design/product.dart';
import 'package:shoes_business/Customers/screeen/my_cart.dart';

class CProductView extends StatefulWidget {
  final String uniqueId;
  const CProductView({super.key, required this.uniqueId});

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
      backgroundColor: const Color(0xFFF3FDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FDFD),
        elevation: 0,
        title: const Text(
          'Explore Products',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Colors.teal, size: 35),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MyCartPage()),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              size: 30,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productList = snapshot.data!.docs;

          if (productList.isEmpty) {
            return const Center(child: Text('No Products uploaded yet.'));
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.only(right: 10,left: 10),
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
            itemCount: productList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Enjoy Your Step with FQs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Yesteryear',
                      fontSize: 38,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                  ),
                );
              } else {
                final product = productList[index - 1];
                return Product(eachProduct: product, uniqueId: widget.uniqueId);
              }
            },
          );
        },
      ),
    );
  }
}
