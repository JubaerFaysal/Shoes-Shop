import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Admin/screen/products_view.dart';
import 'package:shoes_business/Methods/category_method.dart';
import 'package:shoes_business/components/my_button.dart';

class CategoriCart extends StatelessWidget {
  final DocumentSnapshot productCategory;
  const CategoriCart({super.key, required this.productCategory});

  @override
  Widget build(BuildContext context) {
    final imageUrl = productCategory['imageUrl'];
    final name = productCategory['name'];
    final description = productCategory['description'];
    final uniqueId = productCategory['id'];
    return Container(
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
                      builder: (context) => ProductsView(uniqueId: uniqueId),
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
                            CategoryMethod.deleteProductCategory(uniqueId);
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
  }
}
