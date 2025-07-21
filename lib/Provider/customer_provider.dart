import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerProvider extends ChangeNotifier {
  DocumentSnapshot? _customerData;
  bool _isLoading = false;

  DocumentSnapshot? get customerData => _customerData;
  bool get isLoading => _isLoading;

  Future<void> fetchCustomerData() async {
    if (_customerData != null) return; // Already fetched

    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        _customerData = doc;
      }
    } catch (e) {
      debugPrint("Error fetching customer data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
