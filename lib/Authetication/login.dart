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

  // @override
  // void initState() {
  //   super.initState();
  //   _fadeController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1000),
  //   );
  //   _fadeAnimation = Tween<double>(
  //     begin: 0,
  //     end: 1,
  //   ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

  //   _fadeController.forward();
  // }

  void login() async {
    showDialog(context: context, builder: (context) => const MyDialogBox());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      if (context.mounted){
         Navigator.pop(context);
         Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      myAleartDialog(e.toString(), context);
    }
  }

  @override
  void dispose() {
   // _fadeController.dispose();
    email.dispose();
    password.dispose();
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
          child: Column(
            children: [
              Hero(
                tag: 'shoeHero',
                child: Image.asset('assets/images/high-heel-4.png', height: 160),
              ),
              const SizedBox(height: 16),
              const Text(
                "Happy to See You",
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
                      labeltext: "Email",
                      controller: email,
                      obscureText: false,
                      icon: const Icon(Icons.mail, color: Color(0xFFFCD8B4),
                        ),
                    ),
                    const SizedBox(height: 16),
                    MyTextForm(
                      labeltext: "Password",
                      controller: password,
                      obscureText: true,
                      icon: const Icon(Icons.lock, color: Color(0xFFFCD8B4),
                        ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: (){}, child: Text("Forgot Password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 196, 138),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                    ),
                    //const SizedBox(height: 8),
                    MyButton(
                      text: "Login",
                      width: 320,
                      
                      color: const Color.fromARGB(255, 252, 198, 151),
                      fontsize: 17,
                      icon: Icons.login,
                      textcolor: const Color(0xFF35281C),
                      iconColor: const Color(0xFF35281C),
                      buttonBlur: 0.6,
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
                      " Register Now",
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
  );
}
}