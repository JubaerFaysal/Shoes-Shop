// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/components/my_text_form.dart';
import 'package:shoes_business/components/select_date.dart';

class Register extends StatefulWidget {
  final void Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  void register() async {
    showDialog(context: context, builder: (context) => const MyDialogBox());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );
      final uid = credential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email.text.trim(),
        'uid': uid,
        'role': 'customer',
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'DoB': dob.text,
      });
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      myAleartDialog(e.toString(), context);
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    phone.dispose();
    dob.dispose();
    _fadeController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF093949),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Hero(
                  tag: 'shoeHero',
                  child: Image.asset('assets/images/shoes.png', height: 160),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 44,
                    fontFamily: 'Yesteryear',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFCD8B4),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      
                      MyTextForm(
                        labeltext: "*Name",
                        controller: name,
                        icon: const Icon(Icons.person, color: Color(0xFFFCD8B4)),
                      ),
                      const SizedBox(height: 10),
                      MyTextForm(
                        labeltext: "*Phone",
                        controller: phone,
                        inputType: TextInputType.phone,
                        icon: const Icon(Icons.call, color: Color(0xFFFCD8B4)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: dob,
                        readOnly: true,
                        style: const TextStyle(
                          color: Color(0xFFD5A983),
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month, color: Color(0xFFFCD8B4)),
                          labelText: "Date of Birth",
                          labelStyle: TextStyle(
                            color: Color(0xFFFCD8B4),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFCD8B4), width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onTap: () => selectDate(context, dob),
                      ),
                      const SizedBox(height: 10),
                      MyTextForm(
                          labeltext: "*Email",
                          controller: email,
                          icon: const Icon(
                            Icons.mail,
                            color: Color(0xFFFCD8B4),
                          ),
                        ),
                        const SizedBox(height: 10),
                      MyTextForm(
                        labeltext: "*Password",
                        controller: password,
                        obscureText: true,
                        icon: const Icon(Icons.lock, color: Color(0xFFFCD8B4)),
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        text: "Sign Up",
                        width: 320,
                        color: const Color(0xFFD5A983),
                        fontsize: 17,
                        icon: Icons.person_add,
                        iconColor: const Color(0xFF35281C),
                        textcolor: const Color(0xFF35281C),
                        buttonBlur: 0.5,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            register();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[400],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFCD8B4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}