// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shoes_business/Admin/Card%20Design/product_cart.dart';
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
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 42, 54),
        elevation: 0,
        title: const Text(
          'Edit Products',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCD8B4),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Color(0xFFFCD8B4), size: 35),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productList = snapshot.data!.docs;

          if (productList.isEmpty) {
            return const Center(child: Text('No Products uploaded yet.',style: TextStyle(
              fontSize: 16,
              color: Color(0xFFFCD8B4),
              fontFamily: 'Poppins',
            ),));
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCart(eachProduct: product);
            },
          );
        },
      ),

      floatingActionButton: MyButton(
        color: Color(0xFFFCD8B4),

        onPressed: () {
          ProductMethod.addProduct(context, widget.uniqueId);
        },
        text: "Add Product ",
        icon: Icons.add,
        textcolor: const Color.fromARGB(255, 62, 38, 36),
        iconColor: const Color.fromARGB(255, 62, 38, 36) ,
      ),
    );
  }
}
