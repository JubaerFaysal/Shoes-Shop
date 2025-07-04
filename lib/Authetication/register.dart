// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoes_business/components/my_aleart_dialog.dart';
import 'package:shoes_business/components/my_button.dart';
import 'package:shoes_business/components/my_dialog_box.dart';
import 'package:shoes_business/components/my_text_form.dart';
import 'package:shoes_business/components/select_date.dart';


class Register extends StatelessWidget {
  final void Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController dob = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void register() async {
      showDialog(context: context, builder: (context) => const MyDialogBox());
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim());
                if (context.mounted) Navigator.pop(context);
         String uid=userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          'email': email.text.trim(),
          'uid': uid,
          'role': 'customer',
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'DoB': dob.text,
        });
         
      } catch (e) {
         Navigator.pop(context);
        myAleartDialog(e.toString(), context);
      }
     
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 210, 214),
      body: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: 900,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 153, 243, 255),
                      blurRadius: 8,
                      offset: Offset(2, 7),
                    ),
                  ],
                ),
                child: constraints.maxWidth > 600
                    ? Row(
                        children: [
                          SizedBox(
                              height: 320,
                             // child: Image.asset("lib/images/muslimah.png")
                             ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Get Registered Tailor Shop",
                                      style: GoogleFonts.poppins(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyan)),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  MyTextForm(
                                    labeltext: "*Email",
                                    controller: email,
                                    icon: const Icon(Icons.mail),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  MyTextForm(
                                      labeltext: "*Name",
                                      controller: name,
                                      icon: const Icon(Icons.person)),
                                  const SizedBox(height: 10),
                                  MyTextForm(
                                    labeltext: "*Phone",
                                    controller: phone,
                                    inputType: TextInputType.number,
                                    icon: const Icon(Icons.call),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                 
                                  TextFormField(
                                    controller: dob,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 2.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      suffixIcon: Icon(Icons.calendar_month),
                                      labelText: "Date of Birth",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                    ),
                                    onTap: () => selectDate(context, dob),
                                  ),
                                   const SizedBox(
                                    height: 10,
                                  ),
                                  MyTextForm(
                                      labeltext: "Password",
                                      controller: password,
                                      obscureText: true,
                                      icon: const Icon(Icons.lock)),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  MyButton(
                                    text: "Sign Up",
                                    height: 50,
                                    color: Colors.cyan,
                                    fontsize: 18,
                                    icon: Icons.login,
                                    textcolor: Colors.white,
                                    buttonBlur: 0.5,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        register();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepOrangeAccent),
                                      ),
                                      GestureDetector(
                                        onTap: onTap,
                                        child: Text(
                                          " Login Now",
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 0, 212, 46)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          const CircleAvatar(
                            radius: 100,
                            // backgroundImage:
                            //     AssetImage("lib/images/muslimah.png"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Get Registered Tailor Shop",
                                    style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyan)),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyTextForm(
                                  labeltext: "*Email",
                                  controller: email,
                                  icon: const Icon(Icons.mail),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextForm(
                                    labeltext: "*Name",
                                    controller: name,
                                    icon: const Icon(Icons.person)),
                                const SizedBox(height: 10),
                                MyTextForm(
                                  labeltext: "*Phone",
                                  controller: phone,
                                  inputType: TextInputType.number,
                                  icon: const Icon(Icons.call),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: dob,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent,
                                            width: 2.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    suffixIcon: Icon(Icons.calendar_month),
                                    labelText: "Date of Birth",
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                  ),
                                  onTap: () => selectDate(context, dob),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyTextForm(
                                    labeltext: "Password",
                                    controller: password,
                                    obscureText: true,
                                    icon: const Icon(Icons.lock)),
                                const SizedBox(
                                  height: 12,
                                ),
                                MyButton(
                                  text: "Sign Up",
                                  height: 50,
                                  color: Colors.cyan,
                                  fontsize: 18,
                                  icon: Icons.login,
                                  textcolor: Colors.white,
                                  buttonBlur: 0.5,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      register();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.deepOrangeAccent),
                                    ),
                                    GestureDetector(
                                      onTap: onTap,
                                      child: Text(
                                        " Login Now",
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 0, 212, 46)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
