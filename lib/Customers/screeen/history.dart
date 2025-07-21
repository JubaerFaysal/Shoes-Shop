// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/c_product_details.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 42, 54),
        title: Text(
          'History',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCD8B4),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Color(0xFFFCD8B4), size: 35),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("History")
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final historyItems = snapshot.data!.docs;
          if (historyItems.isEmpty) {
            return const Center(
              child: Text('No Product-Categories uploaded yet.'),
            );
          }
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: const Color.fromARGB(255, 13, 105, 135),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item['productName'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFCD8B4),
                    ),
                  ),
                  subtitle: Text(
                    '৳ ${item['price']} x ${item['quantity']}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFCD8B4),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.visibility,
                      color: Color(0xFFFCD8B4),
                    ),
                    onPressed: () async {
                      final productSnap =
                          await FirebaseFirestore.instance
                              .collection('Product_Category')
                              .doc(item['categoryId'])
                              .collection('Products')
                              .doc(item['productId'])
                              .get();

                      final productData = productSnap.data();

                      if (productData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CProductDetails(
                                  eachproduct: productSnap,
                                  uniqueId: item['categoryId'],
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product not found.")),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
