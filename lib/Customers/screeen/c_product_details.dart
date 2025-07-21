// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoes_business/Methods/cart.dart';
import 'package:shoes_business/Methods/payment_method.dart';
import 'package:shoes_business/components/my_button.dart';

class CProductDetails extends StatefulWidget {
  final dynamic eachproduct;
  final String uniqueId;
  const CProductDetails({
    super.key,
    required this.eachproduct,
    required this.uniqueId,
  });

  @override
  State<CProductDetails> createState() => _CProductDetailsState();
}

class _CProductDetailsState extends State<CProductDetails> {
  int? selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.eachproduct;
    final List<dynamic> sizes = product['sizes'] ?? [];
    final int stock = product['stock'] ?? 0;
    final Timestamp? timestamp = product['timestamp'];
    final String formattedDate =
        timestamp != null
            ? DateFormat.yMMMM().format(timestamp.toDate())
            : 'Unknown';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),

      body: Padding(
        padding: const EdgeInsets.only(top: 55),
        child: Column(
          children: [
            Text(
              "Details of ${product['name']}",
              style: const TextStyle(
                fontFamily: 'yesteryear',
                fontSize: 30,
                color: Color(0xFFFCD8B4),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            // Product Image with Hero
            SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Positioned(
                    right: 70,
                    top: 110,
                    child: Container(
                      height: 280,
                      width: 280,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 13, 105, 135),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(150),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 20,
                    child: Hero(
                      tag: product['imageUrl'],
                      child: Image.network(
                        product['imageUrl'],
                        height: 280,
                        width: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //const SizedBox(height: 10),

            // Glass Info Cards
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 9, 61, 77),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade100,
                      blurRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info
                      Center(
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildInfoTile(
                              Icons.label_important,
                              "Brand",
                              product['brand'],
                            ),
                            _buildInfoTile(
                              Icons.scale,
                              "Weight",
                              product['weight'],
                            ),
                            _buildInfoTile(
                              Icons.store,
                              "Stock",
                              stock > 0 ? "$stock pcs" : "Out of Stock",
                            ),
                            _buildInfoTile(
                              Icons.calendar_today,
                              "Added On",
                              formattedDate,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sizes
                      if (sizes.isNotEmpty) ...[
                        Text(
                          "Select Size",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFCD8B4),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children:
                              sizes.map((size) {
                                final isSelected = selectedSize == size;
                                return ChoiceChip(
                                  label: Text(size.toString()),
                                  selected: isSelected,
                                  selectedColor: Color.fromARGB(
                                    255,
                                    245,
                                    214,
                                    184,
                                  ),
                                  backgroundColor: Colors.teal.shade100,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Price Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   colors: [
                          //     Color.fromARGB(255, 7, 94, 123),
                          //     Color.fromARGB(255, 17, 86, 109),
                          //   ],
                          // ),
                          color: Color.fromARGB(255, 7, 42, 54),
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.teal.shade100,
                          //     blurRadius: 2,
                          //     offset: const Offset(0, 1),
                          //   ),
                          // ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Color(0xFFFCD8B4),
                              ),
                            ),
                            Text(
                              "৳ ${product['price']}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFCD8B4),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: MyButton(
                              text: "Add to Cart",
                              onPressed: () async {
                                try {
                                  await CartService().addToCart(
                                    categoryId: widget.uniqueId,
                                    productId: product.id,
                                    productName: product['name'],
                                    price: product['price'],
                                    imageUrl: product['imageUrl'],
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product['name']} added to cart',
                                      ),
                                      backgroundColor: Colors.teal.shade600,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: Icons.shopping_cart,
                              color: const Color.fromARGB(255, 254, 154, 66),
                              textcolor: Color(0xFF35281C),
                              iconColor: Color(0xFF35281C),
                            ),
                          ),
                          const SizedBox(width: 12),
                          MyButton(
                            text: "Buy Now",
                            onPressed: () {
                              showCardPaymentDialog(context, product['price']);
                            },
                            icon: Icons.shopping_bag,
                            color: Color.fromARGB(255, 255, 192, 137),
                            iconColor: Color(0xFF35281C),
                            textcolor: Color(0xFF35281C),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: MyButton(
                          text: "Close",
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icons.close,
                          color: Colors.redAccent,
                          textcolor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      width: 110,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 7, 42, 54),
        borderRadius: BorderRadius.circular(14),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.teal.shade100,
        //     blurRadius: 2,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFFFCD8B4), size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFFFCD8B4),
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFCD8B4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
