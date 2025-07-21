import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Admin/Card%20Design/categori_cart.dart';
import 'package:shoes_business/Admin/screen/global_history.dart';
import 'package:shoes_business/Methods/category_method.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Home"), backgroundColor: Colors.teal),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50,),
            MyButton(
              text: "Log Out",
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllCustomerHistory()),
                );
              },
              icon: Icon(Icons.history),
              color: Colors.blue,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Product_Category')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: MyDialogBox());
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

              return CategoriCart(productCategory: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CategoryMethod.addCategory(context);
        },
        tooltip: "Add Categories",
        child: Icon(Icons.add),
      ),
    );
  }
}
