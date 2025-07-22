import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/components/my_button.dart';

void deleteAlert(DocumentSnapshot eachItem, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          'Delete Item',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFFCD8B4),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text(
            "Are you sure you want to delete this item?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFCD8B4),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        MyButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icons.cancel, 
          text:  "Cancel",
          textcolor: const Color.fromARGB(255, 51, 32, 30),
          iconColor: const Color.fromARGB(255, 51, 32, 30),
         color: Color(0xFFFCD8B4),
        ),
        MyButton(
          onPressed: () {
            eachItem.reference.delete();
            Navigator.pop(context);
          },
          icon: Icons.delete_forever, 
          text: "Delete",
        color: Colors.redAccent,
        ),
      ],
    ),
  );
}
