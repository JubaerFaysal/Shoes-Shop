import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoes_business/Admin/screen/product_details.dart';

class AllCustomerHistory extends StatelessWidget {
  const AllCustomerHistory({super.key});

  Future<String> _getUserPhone(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data()?['phone'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final globalHistoryRef = FirebaseFirestore.instance
        .collection('Globalhistory')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade600,
        title: Text(
          'All Customers History',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: globalHistoryRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyItems = snapshot.data!.docs;

          if (historyItems.isEmpty) {
            return const Center(child: Text("No purchase history available."));
          }

          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final doc = historyItems[index];
              final data = doc.data() as Map<String, dynamic>;
              final userId = data['userId'];

              return FutureBuilder<String>(
                future: _getUserPhone(userId),
                builder: (context, phoneSnapshot) {
                  final phoneNumber = phoneSnapshot.data ?? 'Loading...';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: InkWell(
                      onTap: () async {
                        final productId = data['productId'];
                        final categoryId = data['categoryId'];

                        final productSnap =
                            await FirebaseFirestore.instance
                                .collection('Product_Category')
                                .doc(categoryId)
                                .collection('Products')
                                .doc(productId)
                                .get();

                        final productData = productSnap.data();

                        if (productData != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductDetails(eachproduct: productSnap),
                            ),
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Product details not found."),
                              ),
                            );
                          }
                        }
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'] ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          data['productName'] ?? 'Unknown Product',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "₹ ${data['price']} x ${data['quantity']} \nPhone: $phoneNumber",
                        ),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          onPressed: () async {
                            await doc.reference.delete();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Item marked as done."),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
