// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    backgroundColor:   const Color.fromARGB(255, 7, 42, 54),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Details for ${eachproduct['name']}",
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  color: Color(0xFFFCD8B4),
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
                "Enjoy your shopping with FQ's.\nShoe's App makes your shopping easy and peaceful.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w200,
                  color: Color(0xFFFCD8B4),
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: Color(0xFFFCD8B4)),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 204, 153),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Color.fromARGB(255, 255, 223, 191),
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
                  color: Color(0xFFFCD8B4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price:",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 73, 58, 58),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "₹ ${eachproduct['price']}",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 64, 44, 44),
                        fontSize: 22,
                        fontFamily: 'Poppins',
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
                  Expanded(
                    child: MyButton(
                      text: 'Modify',
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                7,
                                42,
                                54,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Center(
                                child: Text(
                                  "Update Product",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFCD8B4),
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
                                    MyButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icons.cancel,
                                      text: "Cancel",
                                      color: Color(0xFFFCD8B4),
                                      textcolor: const Color.fromARGB(255, 40, 20, 20),
                                     iconColor: const Color.fromARGB(255, 40, 20, 20),
                                    ),
                                    MyButton(
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
                                      icon: Icons.save,
                                      text: "Update",
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icons.edit,
                     color: Colors.blue,
                      iconColor: Colors.white,
                      textcolor: Colors.white,
                      fontsize: 16,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: MyButton(
                      onPressed: () {
                        deleteAlert(eachproduct, context);
                      },
                      icon:  Icons.delete,
                      text: 'Delete ',
                     color: Colors.deepOrange,
                      iconColor: Colors.white,
                      textcolor: Colors.white,
                      fontsize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              MyButton(
                text: "Close",
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.close,

                color: Colors.red,
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
        Icon(icon, color: const Color.fromARGB(255, 13, 105, 135), size: 30),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontFamily: 'Poppins',fontSize: 12, fontWeight: FontWeight.w600,color: Color(0xFFFCD8B4),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFFFCD8B4),
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
        prefixIcon: Icon(icon, color: Color(0xFFFCD8B4)),
        labelText: label,
        hintStyle: TextStyle(color: Color(0xFFFCD8B4)),
        labelStyle: TextStyle(color: Color(0xFFFCD8B4)),
        filled: true,
        fillColor: const Color.fromARGB(255, 7, 42, 54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color.fromARGB(255, 157, 133, 109)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFCD8B4), width: 2),
        ),
      ),
      style: TextStyle(fontFamily: 'Poppins',color: Color(0xFFFCD8B4)),
    );
  }
}
