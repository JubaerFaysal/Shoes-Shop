import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/Card%20design/category.dart';
import 'package:shoes_business/Customers/screeen/customer_drawer.dart';
import 'package:shoes_business/Customers/screeen/my_cart.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
    appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 42, 54),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Explore Categories",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCD8B4),
          ),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFFFCD8B4)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
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
              Icons.shopping_cart,
              size: 28,
              color: Color(0xFFFCD8B4),
            ),
          ),
        ],
      ),

      drawer: CustomerDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Product_Category')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final productCategory = snapshot.data!.docs;

          if (productCategory.isEmpty) {
            return const Center(
              child: Text('No Product-Categories uploaded yet.'),
            );
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
