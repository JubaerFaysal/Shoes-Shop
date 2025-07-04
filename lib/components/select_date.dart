import 'package:flutter/material.dart';

DateTime? selectedDate;

// Function to open date picker
Future<void> selectDate(BuildContext context,TextEditingController date) async {
  
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (picked != null && picked != selectedDate) {
    
      selectedDate = picked;
      date.text =
          "${picked.toLocal()}".split(' ')[0]; 
    
  }
}
