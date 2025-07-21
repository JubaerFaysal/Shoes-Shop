import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showCardPaymentDialog(
  BuildContext context,
  double totalPrice,
) async {
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 7, 42, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Card Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFCD8B4),
                  //fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total Amount: ৳${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFCD8B4),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card Logos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://static.vecteezy.com/system/resources/previews/020/335/998/original/visa-logo-visa-icon-free-free-vector.jpg',
                          width: 50,
                          height: 30,
                        ),
                        const SizedBox(width: 10),

                        Image.network(
                          'https://static.vecteezy.com/system/resources/previews/009/469/637/original/paypal-payment-icon-editorial-logo-free-vector.jpg',
                          width: 50,
                          height: 30,
                        ),
                        Image.network(
                          'https://static.vecteezy.com/system/resources/previews/020/335/998/original/visa-logo-visa-icon-free-free-vector.jpg',
                          width: 50,
                          height: 30,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Form Fields
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                       style: const TextStyle(
                        color: Color(0xFFFCD8B4),
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                        labelText: "Cardholder Name",
                        labelStyle: const TextStyle(
                          color: Color(0xFFFCD8B4),
                          fontFamily: 'Poppins',
                        ),
                        hintText: "Jubaer Ahmed",
                        hintStyle: const TextStyle(
                          color: Color(0xFFFCD8B4),
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFFFCD8B4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFCD8B4), 
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      style: const TextStyle(
                        color: Color(0xFFFCD8B4),
                        fontFamily: 'Poppins',
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Card Number",
                        labelStyle: const TextStyle(
                          color: Color(0xFFFCD8B4),
                          fontFamily: 'Poppins',
                        ),
                        hintText: "1234 5678 9012 3456",
                        hintStyle: const TextStyle(
                          color: Color(0xFFFCD8B4),
                          fontFamily: 'Poppins',
                        ),
                         counterStyle: const TextStyle(
                          color: Color(0xFFFCD8B4), 
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.credit_card,
                          color: Color(0xFFFCD8B4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFCD8B4),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: expiryController,
                            keyboardType: TextInputType.datetime,
                            maxLength: 5,
                            style: const TextStyle(
                              color: Color(0xFFFCD8B4),
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              labelText: "Expiry (MM/YY)",
                              labelStyle: const TextStyle(
                                color: Color(0xFFFCD8B4),
                                fontFamily: 'Poppins',
                              ),
                              hintText: "08/26",
                              hintStyle: const TextStyle(
                                color: Color(0xFFFCD8B4),
                                fontFamily: 'Poppins',
                              ),
                               counterStyle: const TextStyle(
                                color: Color(
                                  0xFFFCD8B4,
                                ), 
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                               focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFCD8B4),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: cvvController,
                            obscureText: true,
                            maxLength: 3,

                            style: TextStyle(
                              color: Color(0xFFFCD8B4),
                              fontFamily: 'Poppins',
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "CVV",
                              labelStyle: const TextStyle(
                                color: Color(0xFFFCD8B4),
                                fontFamily: 'Poppins',
                              ),
                              hintText: "123",
                              hintStyle: const TextStyle(
                                color: Color(0xFFFCD8B4),
                                fontFamily: 'Poppins',
                              ),
                               counterStyle: const TextStyle(
                                color: Color(
                                  0xFFFCD8B4,
                                ), 
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                               focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFCD8B4),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock, color: Color(0xFF35281C)),
                  onPressed: () {
                    final cardNumber = cardNumberController.text.trim();
                    final expiry = expiryController.text.trim();
                    final cvv = cvvController.text.trim();
                    final name = nameController.text.trim();

                    final bool isCardValid = RegExp(
                      r'^\d{16}$',
                    ).hasMatch(cardNumber);
                    final bool isExpiryValid = RegExp(
                      r'^(0[1-9]|1[0-2])\/\d{2}$',
                    ).hasMatch(expiry);
                    final bool isCVVValid = RegExp(r'^\d{3}$').hasMatch(cvv);
                    final bool isNameValid = name.isNotEmpty;

                    if (isCardValid &&
                        isExpiryValid &&
                        isCVVValid &&
                        isNameValid) {
                      Navigator.pop(context, true); // Payment successful
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Invalid card details. Please check again.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  label: Text(
                    "Pay  ৳${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Color(0xFF35281C),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 251, 196, 141),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
      ) ??
      false;
}
