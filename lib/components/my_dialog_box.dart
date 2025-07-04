import 'package:flutter/material.dart';

class MyDialogBox extends StatelessWidget {
  const MyDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.teal),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Loading, please wait...',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ],
                ),
              ),
            );
  }
}