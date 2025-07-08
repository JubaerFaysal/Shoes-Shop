import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void deleteAlert(DocumentSnapshot eachItem, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          'Delete Item',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
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
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel, size: 18),
          label: const Text("Cancel"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            eachItem.reference.delete();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text("Delete"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ),
  );
}
