import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_business/Customers/screeen/history.dart';
import 'package:shoes_business/Provider/customer_provider.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_list_tile.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final customer = provider.customerData;
    return Drawer(
      backgroundColor: Color.fromARGB(255, 11, 62, 79),
      child:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : customer == null
              ? const Center(child: Text("No customer data"))
              : Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 11, 62, 79)
                      // gradient: LinearGradient(
                      //   colors: [
                      //      Color.fromARGB(255, 4, 48, 63),
                      //     Color.fromARGB(255, 212, 235, 254),
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                    ),
                    accountName: Text(
                      customer['name'],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:  Color(0xFFFCD8B4),
                      ),
                    ),
                    accountEmail: Text(
                      customer['email'],
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color:  Color(0xFFFCD8B4),
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
                              MaterialPageRoute(builder: (_) => const History()),
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
    );
  }
}
