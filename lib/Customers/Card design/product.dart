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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 95,),
          height: 230,
          width: 280,
         decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [const Color.fromARGB(255, 236, 251, 251), Colors.teal.shade200],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            color: Color.fromARGB(255, 13, 105, 135),
             boxShadow: [
              BoxShadow(
                color: Color(0xFFFCD8B4),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Column(
          children: [
            Hero(
              tag: eachProduct['imageUrl'],
              child: Image.network(
                eachProduct['imageUrl'],
                //  height: 200,
                //  width: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              eachProduct['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                fontFamily: 'Poppins',
                color: Color(0xFFFCD8B4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Price:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,    
                      fontSize: 17,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFCD8B4),
                    ),
                  ),
                  Text(
                    "${eachProduct['price']} ৳",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFCD8B4),
                    ),
                  ),  
                ]
              )
            ),
            MyButton(
              onPressed: () {
               Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(
                      milliseconds: 800,
                    ), 
                    pageBuilder:
                        (_, __, ___) => CProductDetails(
                          eachproduct: eachProduct,
                          uniqueId: uniqueId,
                        ),
                  ),
                );

              },
              text: "View details",
              color: Color(0xFFFCD8B4),
              iconColor: Color(0xFF35281C),
              textcolor: Color(0xFF35281C),
              icon: Icons.remove_red_eye,
            ),
          ],
        ),
      ],
    );
    
  }
}
