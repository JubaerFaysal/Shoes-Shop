import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart({
    required String categoryId,
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final cartRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('Cart')
        .doc(
            '$categoryId-$productId'); // unique ID based on inventory + product

    final doc = await cartRef.get();

    if (doc.exists) {
      // If already in cart, increase quantity
      await cartRef.update({
        'quantity': FieldValue.increment(1),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // If new item
      await cartRef.set({
        'categoryId': categoryId,
        'productId': productId,
        'productName': productName,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
