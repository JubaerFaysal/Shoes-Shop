import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/c_product_view.dart';
import 'package:shoes_business/components/my_button.dart';

class Category extends StatelessWidget {
  final DocumentSnapshot productCategory;
  const Category({super.key, required this.productCategory});

  @override
  Widget build(BuildContext context) {
    final imageUrl = productCategory['imageUrl'];
    final name = productCategory['name'];
    final description = productCategory['description'];
    final uniqueId = productCategory['id'];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          //padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 40, left: 70, right: 10,bottom: 15),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.teal.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Positioned(
          left: 15,
          child: Image.network(
            imageUrl,
            height: 180,
            width: 180,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 200,
          top: 50,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Text(
                name,
                style:  TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
               MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CProductView(uniqueId: uniqueId),
                    ),
                  );
                },
                icon: Icons.remove_red_eye,
                text: "Explore",
                color: Colors.teal,
              ),
              
            ],
          ),
        ),
       
      ],
    );
   
  }
}
