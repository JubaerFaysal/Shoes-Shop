import 'package:flutter/material.dart';

void myAleartDialog(String message,BuildContext context) {
   showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: const Color.fromARGB(255, 7, 42, 54),
          title: const Text(
            'Error',
            style: TextStyle(
                //fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Color(0xFFFCD8B4),
            ),
          ),
           content:  Text(message,style: TextStyle(fontFamily: 'Poppins',color: Color(0xFFFCD8B4)),),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFCD8B4),
                ),
              ),
            ),
          ],
        ),
      );
}
