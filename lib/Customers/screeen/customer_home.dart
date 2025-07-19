import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/Card%20design/category.dart';
import 'package:shoes_business/Customers/screeen/customer_drawer.dart';
import 'package:shoes_business/Customers/screeen/my_cart.dart';
import 'package:shoes_business/components/my_dialog_box.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  DocumentSnapshot? customerSnapshot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomerData();
  }

  Future<void> fetchCustomerData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      setState(() {
        customerSnapshot = snapshot;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || customerSnapshot == null) {
      return const Scaffold(body: Center(child: MyDialogBox(
        content: 'Loading customer data..',
      )));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3FDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FDFD),
        title: const Text(
          "Customers",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins',
            color: Colors.teal,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
         leading: Builder(
          builder:
              (context) => IconButton(
                icon:  Icon(Icons.menu, color: Colors.teal),
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
              Icons.shopping_cart_outlined,
              size: 30,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      drawer: CustomerDrawer(customerSnapshot: customerSnapshot!),
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
