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
          margin: const EdgeInsets.only(
            top: 40,
            left: 70,
            right: 15,
            bottom: 15,
          ),
          height: 130,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 105, 135),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFCD8B4),
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          left: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 180,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 210,
          top: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFCD8B4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
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
                icon: Icons.remove_red_eye,
                text: "Explore",
                width: 120,
                height: 40,
                fontsize: 14,
                color: const Color(0xFFFCD8B4),
                iconColor: const Color(0xFF35281C),
                textcolor: const Color(0xFF35281C),
                buttonBlur: 0.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
