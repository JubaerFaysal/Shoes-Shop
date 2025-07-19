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
       backgroundColor: const Color(0xFFF3FDFD),
     
      body: SafeArea(
        child: Column(
          children: [
            Text(
              product['name'],
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                color: Colors.teal,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Product Image with Hero
            Hero(
              tag: product['imageUrl'],
              child: Image.network(
                product['imageUrl'],
                 height: 300,
                // width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Glass Info Cards
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, -6),
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
                            color: Colors.teal.shade900,
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
                                  selectedColor: Colors.teal.shade300,
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
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.shade400,
                              Colors.teal.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.shade100,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "৳ ${product['price']}",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                              color: Colors.orange,
                              textcolor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: MyButton(
                              text: "Buy Now",
                              onPressed: () {
                                showCardPaymentDialog(
                                  context,
                                  product['price'],
                                );
                              },
                              icon: Icons.shopping_bag,
                              color: Colors.teal,
                              textcolor: Colors.white,
                            ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
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
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
