import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/c_product_details.dart';
import 'package:shoes_business/components/my_button.dart';

class Product extends StatelessWidget {
  final DocumentSnapshot eachProduct;
  final String uniqueId;
  const Product({super.key, required this.eachProduct,required this.uniqueId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 184, 255, 246),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
            child: Image.network(
              eachProduct['imageUrl'],
              height: 200,
              width: 200,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            eachProduct['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Color.fromARGB(255, 27, 76, 44),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Color.fromARGB(255, 27, 76, 44),
                  ),
                ),
                Text(
                  "${eachProduct['price']} Tk",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Color.fromARGB(255, 27, 76, 44),
                  ),
                ),
              ],
            ),
          ),
          MyButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CProductDetails(eachproduct: eachProduct, uniqueId: uniqueId,),
                ),
              );
            },
            text: "Viw details",
            color: const Color.fromARGB(255, 8, 174, 14),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
