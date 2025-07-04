import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? height;
  final double? width;
  final Color? color;
  final double? fontsize;
  final double? buttonBlur;
  final Color? textcolor;

  const MyButton({
    super.key,
    this.height,
    this.width,
    this.onPressed,
    required this.text,
    this.icon,
    this.color,
    this.fontsize,
    this.buttonBlur,
    this.textcolor
  });

  @override
  Widget build(BuildContext context) {
    // Screen size for responsiveness
   // final screenSize = MediaQuery.of(context).size;
   // final screenWidth = screenSize.width;

    return ElevatedButton.icon(
      onPressed: onPressed,
      
      style: ElevatedButton.styleFrom(
        
        backgroundColor: color ?? const Color.fromARGB(255, 237, 4, 4),
        foregroundColor: Colors.white,
        
       // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 34, 34, 34),
      ),
      icon: Icon(icon, size: 18,color: Colors.white,), 
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: fontsize , 
          fontWeight: FontWeight.w600,
          color: textcolor??Colors.white
        ),
      ),
    );
  }
}
