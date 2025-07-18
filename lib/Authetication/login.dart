// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/components/my_text_form.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  void login() async {
    showDialog(context: context, builder: (context) => const MyDialogBox());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      myAleartDialog(e.toString(), context);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
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
                  Text(
                    "Welcome Back",
                    style: const TextStyle(
                      fontSize: 42,
                      fontFamily: 'Yesteryear',
                      color: Colors.teal,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        MyTextForm(
                          labeltext: "Email",
                          controller: email,
                          obscureText: false,
                          icon: const Icon(Icons.mail),
                        ),
                        const SizedBox(height: 16),
                        MyTextForm(
                          labeltext: "Password",
                          controller: password,
                          obscureText: true,
                          icon: const Icon(Icons.lock),
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                          text: "Login",
                         // height: 50,
                         width: 320,
                          color: Colors.teal,
                          fontsize: 17,
                          icon: Icons.login,
                          textcolor: Colors.white,
                          buttonBlur: 0.5,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              login();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          " Register Now",
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
