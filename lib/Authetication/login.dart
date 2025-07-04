// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/components/my_text_form.dart';

class Login extends StatelessWidget {
  final void Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final formKey = GlobalKey<FormState>();

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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 250),
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth > 600
                  ? Row(
                    children: [
                      SizedBox(
                        height: 320,
                        // child: Image.asset("lib/images/muslimah.png"),
                      ),

                      const SizedBox(width: 30),
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome Back",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 20),
                              MyTextForm(
                                labeltext: "Email",
                                controller: email,
                                icon: const Icon(Icons.mail),
                              ),
                              const SizedBox(height: 10),
                              MyTextForm(
                                labeltext: "Password",
                                controller: password,
                                obscureText: true,
                                icon: const Icon(Icons.lock),
                              ),
                              const SizedBox(height: 12),
                              MyButton(
                                text: "Login",
                                height: 50,
                                color: Colors.cyan,
                                fontsize: 18,
                                icon: Icons.login,
                                textcolor: Colors.white,
                                buttonBlur: 0.5,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    login();
                                  }
                                },
                              ),
                              const SizedBox(height: 15),
                              //don't have accout?register
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onTap,
                                    child: Text(
                                      " Register Now",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          212,
                                          46,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      const CircleAvatar(
                        radius: 100,
                        // backgroundImage: AssetImage(
                        //   "lib/images/muslimah.png",
                        // ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome Back",
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 20),
                            MyTextForm(
                              labeltext: "Email",
                              controller: email,
                              obscureText: false,
                              icon: const Icon(Icons.mail),
                            ),
                            const SizedBox(height: 10),
                            MyTextForm(
                              labeltext: "Password",
                              controller: password,
                              obscureText: true,
                              icon: const Icon(Icons.lock),
                            ),
                            const SizedBox(height: 12),
                            MyButton(
                              text: "Login",
                              height: 50,
                              color: Colors.teal,
                              fontsize: 18,
                              icon: Icons.login,
                              textcolor: Colors.white,
                              buttonBlur: 0.5,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  login();
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            //don't have accout?register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: onTap,
                                  child: Text(
                                    " Register Now",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                        255,
                                        0,
                                        212,
                                        46,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
            },
          ),
        ),
      ),
    );
  }
}
