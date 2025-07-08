// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shoes_business/components/delete_aleart.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';
import 'package:shoes_business/components/my_button.dart';

class ProductDetails extends StatelessWidget {
  final DocumentSnapshot eachproduct;
  const ProductDetails({super.key, required this.eachproduct});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController nameController =
                              TextEditingController(text: eachproduct['name']);
                          TextEditingController priceController =
                              TextEditingController(text: eachproduct['price'].toString());
                          TextEditingController stockController =
                              TextEditingController(
                                text: eachproduct['stock'].toString(),
                              );
                          TextEditingController brandController =
                              TextEditingController(text: eachproduct['brand']);
                          TextEditingController weightcontroller =
                              TextEditingController(
                                text: eachproduct['weight'],
                              );

                          return AlertDialog(
                            backgroundColor: const Color(0xFFE6F5F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Center(
                              child: Text(
                                "Update Product",
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStyledTextField(
                                    controller: nameController,
                                    label: "Product Name",
                                    // hint:
                                    //     "Was: ${product['Product']}",
                                    icon: Icons.edit,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStyledTextField(
                                    controller: priceController,
                                    label: "Price",
                                    // hint:
                                    //     "Was: ₹ ${product['Price']}",
                                    icon: Icons.attach_money,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStyledTextField(
                                    controller: brandController,
                                    label: "Brand",
                                    // hint:
                                    //     "Was: ₹ ${product['Brand']}",
                                    icon: Icons.label_important,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStyledTextField(
                                    controller: weightcontroller,
                                    label: "Weight",
                                    // hint:
                                    //     "Was: ₹ ${product['Size']}",
                                    icon: Icons.format_size,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildStyledTextField(
                                    controller: stockController,
                                    label: "Stock",
                                    // hint:
                                    //     "Was: ₹ ${product['Stock']}",
                                    icon: Icons.store,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.cancel),
                                    label: const Text("Cancel"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade100,
                                      foregroundColor: Colors.teal.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final name = nameController.text.trim();
                                      final brand = brandController.text.trim();
                                      final weight =
                                          weightcontroller.text.trim();
                                      final priceText =
                                          priceController.text.trim();
                                      final stockText =
                                          stockController.text.trim();
                                      try {
                                        final double price = double.parse(
                                          priceText,
                                        );
                                        final int stock = int.parse(stockText);
                                        await eachproduct.reference.update({
                                          'name': name,
                                          'brand': brand,
                                          'weight': weight,
                                          'price': price,
                                          'stock': stock,
                                          'timestamp':
                                              FieldValue.serverTimestamp(),
                                        });
                                        Navigator.pop(context);
                                      } catch (e) {
                                        myAleartDialog(
                                          "Unable to Update",
                                          context,
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.save),
                                    label: const Text("Update"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: Text("Modify", style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      deleteAlert(eachproduct, context);
                    },
                    icon: const Icon(Icons.delete),
                    label: Text("Delete", style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    //required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        hintStyle: TextStyle(color: Colors.teal.shade300),
        labelStyle: TextStyle(color: Colors.teal.shade700),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.black87),
    );
  }
}
