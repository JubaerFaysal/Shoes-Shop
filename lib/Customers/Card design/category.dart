import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/c_product_view.dart';
import 'package:shoes_business/components/my_button.dart';

class Category extends StatelessWidget {
  final DocumentSnapshot productCategory;
  const Category({super.key,required this.productCategory});

  @override
  Widget build(BuildContext context) {
     final imageUrl = productCategory['imageUrl'];
    final name = productCategory['name'];
    final description = productCategory['description'];
    final uniqueId = productCategory['id'];

    return Container(
      // padding: EdgeInsets.all(8),
      height: 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 184, 255, 246),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16.0,
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
                      builder: (context) => CProductView(uniqueId: uniqueId),
                    ),
                  );
                },

                text: "Visite",
                color: const Color.fromARGB(255, 8, 174, 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}