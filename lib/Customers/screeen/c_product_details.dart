// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shoes_business/Methods/cart.dart';
import 'package:shoes_business/components/my_button.dart';

class CProductDetails extends StatelessWidget {
  final DocumentSnapshot eachproduct;
  final String uniqueId;
  const CProductDetails({super.key, required this.eachproduct,required this.uniqueId});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> sizes = eachproduct['sizes'] ?? [];
    final int stock = eachproduct['stock'] ?? 0;
    final Timestamp? timestamp = eachproduct['timestamp'];
    final String formattedDate =
        timestamp != null
            ? DateFormat.yMMMd().format(timestamp.toDate())
            : 'Unknown';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Details for ${eachproduct['name']}",
                style: GoogleFonts.poppins(
                  color: Colors.teal.shade700,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  eachproduct['imageUrl'],
                  width: 270,
                  height: 270,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Enjoy your shopping with FQ's.\nTailor's App makes our shopping easy and peaceful.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.teal.shade300),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoTile(
                    Icons.label_important,
                    "Brand",
                    eachproduct['brand'],
                  ),
                  _buildInfoTile(Icons.scale, "Weight", eachproduct['weight']),
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
              const SizedBox(height: 10),

              if (sizes.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Available Sizes:",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children:
                      sizes.map((size) {
                        return Chip(
                          label: Text(
                            size.toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Colors.teal.shade100,
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price:",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "₹ ${eachproduct['price']}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 💳 Buy Now & Add to Cart Buttons
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      text: "Add to Cart",
                      onPressed: () async {
                        try {
                          await CartService().addToCart(
                            categoryId: uniqueId,
                            productId: eachproduct.id,
                            productName: eachproduct['name'],
                            price: eachproduct['price'],
                            imageUrl: eachproduct['imageUrl'],
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${eachproduct['name']} added to cart',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      icon: Icons.shopping_cart_outlined,
                      color: Colors.orange,
                      textcolor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyButton(
                      text: "Buy Now",
                      onPressed: () {
                        //TODO: Implement cart add logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Proceeding to buy")),
                        );
                      },
                      icon: Icons.shopping_bag,
                      color: Colors.teal,
                      textcolor: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              MyButton(
                text: "Close",
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.close,

                color: Colors.redAccent,
                textcolor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal, size: 30),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
