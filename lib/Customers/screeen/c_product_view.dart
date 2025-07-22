import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shoes_business/Customers/Card%20design/product.dart';
import 'package:shoes_business/Customers/screeen/my_cart.dart';
import 'package:shoes_business/Provider/cart_provider.dart';

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
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 42, 54),
        elevation: 0,
        title: const Text(
          'Explore Products',
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
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyCartPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 28,
                      color: Color(0xFFFCD8B4),
                    ),
                  ),
                  if (cartProvider.cartItemCount > 0)
                    Positioned(
                      right: 6,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '${cartProvider.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
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
            itemCount: productList.length + 1,
            itemBuilder: (context, index) {

              if (index == productList.length) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Enjoy Your Step with FQs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Yesteryear',
                      fontSize: 38,
                      color: Color(0xFFFCD8B4),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                    ),
                  ),
                );
              } else {
                final product = productList[index ];
                return Product(eachProduct: product, uniqueId: widget.uniqueId);
              }
            },
          );
        },
      ),
    );
  }
}
