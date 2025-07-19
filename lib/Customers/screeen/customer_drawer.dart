import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Customers/screeen/history.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_list_tile.dart';

class CustomerDrawer extends StatelessWidget {
  final DocumentSnapshot customerSnapshot;
  const CustomerDrawer({super.key, required this.customerSnapshot});

  @override
  Widget build(BuildContext context) {
    final userData = customerSnapshot.data() as Map<String, dynamic>;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Color.fromARGB(255, 212, 235, 254)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              userData['name'] ?? 'No Name',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              userData['email'] ?? 'No Email',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/user-2.png"),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                MyListTile(
                  icon: Icons.home,
                  title: "H O M E",
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                MyListTile(
                  icon: Icons.people,
                  title: "My Profile",
                  onTap: () {
                    // Navigate to profile
                  },
                ),
                const SizedBox(height: 10),
                MyListTile(
                  icon: Icons.history,
                  title: "H I S T O R Y",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const History(),
                    ));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MyButton(
              text: "LogOut",
              color: Colors.red.shade400,
              icon: Icons.logout,
              textcolor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              fontsize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
