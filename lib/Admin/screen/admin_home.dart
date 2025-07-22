import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/Admin/Card%20Design/categori_cart.dart';
import 'package:shoes_business/Admin/screen/global_history.dart';
import 'package:shoes_business/Methods/category_method.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/components/my_list_tile.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 42, 54),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Categories",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCD8B4),
          ),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFFFCD8B4)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),),
      drawer: Drawer(
        backgroundColor:  Color.fromARGB(255, 7, 42, 54),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 11, 62, 79),
              
              ),
              accountName: Text(
                "Jubaer Ahmed Faysal",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFCD8B4),
                ),
              ),
              accountEmail: Text(
                "jubaerfaysal@gmail.com",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFFFCD8B4),
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/user-2.png"),
              ),
            ),
            Expanded(
              child: ListView(
                //padding: EdgeInsets.zero,
                children: [
                  MyListTile(
                    icon: Icons.home,
                    title: "H O M E",
                    onTap: () => Navigator.pop(context),
                    iconcolor: const Color(0xFFFCD8B4),
                    textcolor: const Color(0xFFFCD8B4),
                    tilecolor: const Color.fromARGB(255, 13, 105, 135),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    icon: Icons.people,
                    title: "My Profile",
                    onTap: () {
                      // Navigate to profile
                    },
                    iconcolor: const Color(0xFFFCD8B4),
                    textcolor: const Color(0xFFFCD8B4),
                    tilecolor: const Color.fromARGB(255, 13, 105, 135),
                  ),
                  const SizedBox(height: 10),
                  MyListTile(
                    icon: Icons.history,
                    title: "H I S T O R Y",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AllCustomerHistory()),
                      );
                    },
                    iconcolor: const Color(0xFFFCD8B4),
                    textcolor: const Color(0xFFFCD8B4),
                    tilecolor: Color.fromARGB(255, 13, 105, 135),
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Product_Category')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: MyDialogBox());
          }

          final productCategory = snapshot.data!.docs;

          if (productCategory.isEmpty) {
            return const Center(
              child: Text('No Product-Categories uploaded yet.'),
            );
          }

          return ListView.builder(
            itemCount: productCategory.length,
            itemBuilder: (context, index) {
              final product = productCategory[index];

              return CategoriCart(productCategory: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 252, 192, 132),
        onPressed: () {
          CategoryMethod.addCategory(context);
        },
        tooltip: "Add Categories",
        child: Icon(Icons.add),
      ),
    );
  }
}
