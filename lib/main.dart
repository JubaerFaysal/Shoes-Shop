import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_business/Authetication/auth_gate.dart';
import 'package:shoes_business/Provider/cart_provider.dart';
import 'package:shoes_business/Provider/customer_provider.dart';
import 'package:shoes_business/Provider/splash_provider.dart';
import 'package:shoes_business/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SplashProvider()),
      ChangeNotifierProvider(create: (_) => CustomerProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()..listenToCart()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoes Business',
      home: AuthGate(),
    );
  }
}
