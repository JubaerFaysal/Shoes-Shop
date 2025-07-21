import 'package:flutter/material.dart';

class MyDialogBox extends StatelessWidget {
  final String? content;
  const MyDialogBox({super.key, this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF082C38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFCD8B4)),
            ),
            SizedBox(height: 20.0),
            Text(
              content ?? 'Loading, please wait...',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFCD8B4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
