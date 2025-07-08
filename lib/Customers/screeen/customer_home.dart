import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/Cart/category.dart';
import 'package:shoes_business/components/my_button.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers"),),
      drawer: Drawer(
        child: MyButton(text: "Logout",onPressed: () => FirebaseAuth.instance.signOut(),),
      ),
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product_Category').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productCategory = snapshot.data!.docs;

          if (productCategory.isEmpty) {
            return const Center(
                child: Text('No Product-Categories uploaded yet.'));
          }

          return ListView.builder(
            itemCount: productCategory.length,
            itemBuilder: (context, index) {
              final product = productCategory[index];
             return Category(productCategory: product);
            },
          );
        },
      ),
    );
  }
}