import 'package:flutter/material.dart';

class MyTextForm extends StatelessWidget {
  final String labeltext;
  final bool? obscureText;
  final TextEditingController controller;
  final Color? color;
  final Icon? icon;
  
  final TextInputType? inputType;
  const MyTextForm(
      {super.key,
      required this.labeltext,
      this.obscureText,
      required this.controller,
      this.icon,
      this.color,
     
      this.inputType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText??false,
      style: const TextStyle(
        color: Color(0xFFFCD8B4),
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFCD8B4), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        suffixIcon: icon,
        labelText: labeltext,
        labelStyle: const TextStyle(color: Color(0xFFFCD8B4),
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter the $labeltext";
        }
        return null;
      },
    );
  }
}
