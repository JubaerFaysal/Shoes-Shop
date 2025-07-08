import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Admin/screen/product_details.dart';

class ProductCart extends StatelessWidget {
  final DocumentSnapshot eachProduct;
  const ProductCart({super.key, required this.eachProduct});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(eachproduct: eachProduct,),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 1.5,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                eachProduct['imageUrl'],
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              eachProduct['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Click for Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.green,
                    ),
                  ),

                  Container(
                    width: 35,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 26, 48, 96),
                    ),
                    child: const Icon(
                      Icons.ads_click,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
