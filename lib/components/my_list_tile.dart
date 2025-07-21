import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? tilecolor;
  final Color? iconcolor;
  final Color? textcolor;
  final VoidCallback? onTap;

  const MyListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.tilecolor,
    this.iconcolor,
    this.textcolor,
  });

  @override
  Widget build(BuildContext context) {
   // final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ListTile(
        
        leading: Icon(
          icon,
          color: iconcolor ?? Colors.cyanAccent,
          size: 16, // Responsive icon size
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16, // Responsive font size
            fontWeight: FontWeight.w500,
            color: textcolor ?? Colors.white,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16, // Responsive trailing icon
        ),
        onTap: onTap,
      
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
         
        ),
        tileColor: tilecolor ??  const Color.fromARGB(255, 3, 198, 179),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8, // Responsive horizontal padding
          vertical: 8, // Responsive vertical padding
        ),
      ),
    );
  }
}
