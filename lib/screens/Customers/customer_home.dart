import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/components/my_button.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers"),),
      body: MyButton(text: "Logout",
        onPressed: () {
          //Navigator.pop(context);
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}