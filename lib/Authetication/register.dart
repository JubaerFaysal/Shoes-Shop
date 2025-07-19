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
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Hero(
                    tag: 'shoeHero',
                    child: Image.asset('assets/images/high-heels.png', height: 150),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Create Account",
                    style: const TextStyle(
                      fontSize: 34,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextForm(
                          labeltext: "*Email",
                          controller: email,
                          icon: const Icon(Icons.mail),
                        ),
                        const SizedBox(height: 10),
                        MyTextForm(
                          labeltext: "*Name",
                          controller: name,
                          icon: const Icon(Icons.person),
                        ),
                        const SizedBox(height: 10),
                        MyTextForm(
                          labeltext: "*Phone",
                          controller: phone,
                          inputType: TextInputType.phone,
                          icon: const Icon(Icons.call),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: dob,
                          readOnly: true,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month),
                            labelText: "Date of Birth",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          onTap: () => selectDate(context, dob),
                        ),
                        const SizedBox(height: 10),
                        MyTextForm(
                          labeltext: "*Password",
                          controller: password,
                          obscureText: true,
                          icon: const Icon(Icons.lock),
                        ),
                        const SizedBox(height: 16),
                        MyButton(
                          text: "Sign Up",
                          //height: 60,
                          width: 320,
                          color: Colors.teal,
                          fontsize: 17,
                          icon: Icons.person_add,
                          textcolor: Colors.white,
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
                        style:  const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          " Login Now",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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
