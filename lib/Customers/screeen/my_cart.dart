// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/c_product_details.dart';
import 'package:shoes_business/Methods/payment_method.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade500,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          // Calculate total price
          totalPrice = 0;
          for (var item in cartItems) {
            final data = item.data() as Map<String, dynamic>;

            final price = double.tryParse(data['price'].toString()) ?? 0;
            final quantity = data['quantity'] ?? 1;

            totalPrice += price * quantity;
          }

          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final data = item.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          data['productName'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '₹ ${data['price']} x ${data['quantity']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () async {
                                final productSnap =
                                    await FirebaseFirestore.instance
                                        .collection('Product_Category')
                                        .doc(data['categoryId'])
                                        .collection('Products')
                                        .doc(data['productId'])
                                        .get();

                                final productData = productSnap.data();

                                if (productData != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CProductDetails(
                                            eachproduct: productSnap,
                                            uniqueId: data['categoryId'],
                                          ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Product not found."),
                                    ),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text("Remove Item"),
                                        content: const Text(
                                          "Are you sure you want to remove this item from the cart?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userId)
                                      .collection('Cart')
                                      .doc(item.id)
                                      .delete();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Total price & Buy Now
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  border: const Border(
                    top: BorderSide(color: Colors.grey, width: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ₹ ${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        //final userId = FirebaseAuth.instance.currentUser?.uid;
                        // final cartRef = FirebaseFirestore.instance
                        //     .collection('users')
                        //     .doc(userId)
                        //     .collection('Cart');

                        final userHistoryRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('History');

                        final globalHistoryRef = FirebaseFirestore.instance
                            .collection(
                              'Globalhistory',
                            ); // Global history for admin

                        final cartSnapshot = await cartRef.get();

                        bool stockOkay = true;
                        List<String> outOfStockItems = [];

                        // Step 1: Check stock before payment
                        for (var doc in cartSnapshot.docs) {
                          final cartData = doc.data();
                          final productId = cartData['productId'];
                          final categoryId = cartData['categoryId'];
                          final quantity = cartData['quantity'];

                          final productSnap =
                              await FirebaseFirestore.instance
                                  .collection('Product_Category')
                                  .doc(categoryId)
                                  .collection('Products')
                                  .doc(productId)
                                  .get();

                          if (!productSnap.exists) {
                            stockOkay = false;
                            outOfStockItems.add(cartData['productName']);
                            continue;
                          }

                          final productData = productSnap.data()!;
                          final stock = productData['stock'] ?? 0;

                          if (stock < quantity) {
                            stockOkay = false;
                            outOfStockItems.add(cartData['productName']);
                          }
                        }

                        if (!stockOkay) {
                          myAleartDialog(
                            "The following items are out of stock or have insufficient stock:\n\n${outOfStockItems.join('\n')}",
                            context,
                          );
                          return;
                        }

                        // Step 2: Proceed to payment
                        bool paymentSuccess = await showCardPaymentDialog(
                          context,
                          totalPrice,
                        );

                        if (!paymentSuccess) {
                          myAleartDialog('Payment failed', context);
                          return;
                        }

                        // Step 3: Payment successful → move to user & global history, delete from cart, decrement stock
                        WriteBatch batch = FirebaseFirestore.instance.batch();

                        for (var doc in cartSnapshot.docs) {
                          final cartData = doc.data();
                          final productId = cartData['productId'];
                          final categoryId = cartData['categoryId'];
                          final quantity = cartData['quantity'];

                          final timestamp = FieldValue.serverTimestamp();

                          // Add to user's History
                          final userHistoryDoc = userHistoryRef.doc();
                          batch.set(userHistoryDoc, {
                            ...cartData,
                            'timestamp': timestamp,
                          });

                          // Add to global History
                          final globalHistoryDoc = globalHistoryRef.doc();
                          batch.set(globalHistoryDoc, {
                            ...cartData,
                            'userId': userId, // Add userId for tracking
                            'timestamp': timestamp,
                          });

                          // Delete from Cart
                          batch.delete(doc.reference);

                          // Decrement stock
                          final productRef = FirebaseFirestore.instance
                              .collection('Product_Category')
                              .doc(categoryId)
                              .collection('Products')
                              .doc(productId);

                          batch.update(productRef, {
                            'Stock': FieldValue.increment(-quantity),
                          });
                        }

                        await batch.commit();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Payment successful. Items moved to history.",
                              ),
                            ),
                          );
                        }
                      },

                      icon: const Icon(Icons.payment),
                      label: const Text("Buy Now"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
