import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  int _cartItemCount = 0;
  int get cartItemCount => _cartItemCount;

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  void listenToCart() {
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .snapshots()
        .listen((snapshot) {
          _cartItemCount = snapshot.docs.length;
          notifyListeners();
        });
  }
}
