import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Admin/screen/admin_home.dart';
import 'package:shoes_business/Authetication/splash_screen.dart';
import 'package:shoes_business/Customers/screeen/customer_home.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> getRedirectScreen(User user) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!doc.exists) {
      return const LoginOrRegister(); // Fallback if user doc not found
    }

    final role = doc['role'];
    if (role == 'customer') {
      return const CustomerHome();
    } else {
      return const AdminHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 9, 53, 68),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Not logged in
          if (!snapshot.hasData) {
            return const ShoeSplashScreen();
          }

          // Logged in, check role
          return FutureBuilder<Widget>(
            future: getRedirectScreen(snapshot.data!),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: MyDialogBox(
                    content: 'Please wait while we check your role.',
                  ),
                );
              } else if (roleSnapshot.hasError) {
                return Center(
                  child: Text("Error loading role: ${roleSnapshot.error}"),
                );
              } else {
                return roleSnapshot.data!;
              }
            },
          );
        },
      ),
    );
  }
}
