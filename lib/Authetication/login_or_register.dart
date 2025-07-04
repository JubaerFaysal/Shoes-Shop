import 'package:flutter/material.dart';
import 'package:shoes_business/Authetication/login.dart';
import 'package:shoes_business/Authetication/register.dart';





class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show the login page
  bool showLoginpage=true;
  //toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginpage=!showLoginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginpage){
      return Login(onTap: togglePages);
    }
    else{
      return Register (onTap: togglePages);
    }
  }
}