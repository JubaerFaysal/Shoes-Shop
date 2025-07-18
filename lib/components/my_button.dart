import 'package:flutter/material.dart';

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
  final Color? iconColor;

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
    this.textcolor,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    // Screen size for responsiveness
   // final screenSize = MediaQuery.of(context).size;
   // final screenWidth = screenSize.width;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        
        style: ElevatedButton.styleFrom(
          
          backgroundColor: color ?? const Color.fromARGB(255, 237, 4, 4),
          foregroundColor: Colors.white,
           padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          
          elevation: 3,
          shadowColor: const Color.fromARGB(255, 34, 34, 34),
        ),
        icon: Icon(icon, size: 20,color: iconColor?? Colors.white,), 
        label: Text(
          text,
          style:  TextStyle(
            fontSize: fontsize ,
            fontFamily: 'Poppins',
            color: textcolor??Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
         
        ),
      ),
    );
  }
}
