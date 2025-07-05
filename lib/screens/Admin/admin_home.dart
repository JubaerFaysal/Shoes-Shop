import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Methods/category_method.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/screens/Admin/products_view.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Home"), backgroundColor: Colors.teal),
       body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Product_Category').snapshots(),
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
              final imageUrl = product['imageUrl'];
              final name = product['name'];
              final description = product['description'];
              final uniqueId = product['id'];

              return Container(
                // padding: EdgeInsets.all(8),
                height: 200,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 255, 254),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 174, 14),
                          ),
                        ),
                        Text(description),
                        const SizedBox(height: 10),
                        MyButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProductsView(uniqueId: uniqueId),
                              ),
                            );
                          },
                          text: "Visite",
                          color: const Color.fromARGB(255, 8, 174, 14),
                          
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text(
                                  'Delete Product',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 8, 174, 14),
                                  ),
                                ),
                                content: const Text("Are you sure?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 8, 174, 14),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      CategoryMethod.deleteProductCateoriy(
                                        uniqueId,
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 8, 174, 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 198, 36, 24),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              );
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
