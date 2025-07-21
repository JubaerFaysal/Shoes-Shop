import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_business/Provider/splash_provider.dart';
import 'package:shoes_business/components/my_button.dart';
import 'login_or_register.dart'; // Replace with your actual screen

class ShoeSplashScreen extends StatefulWidget {
  const ShoeSplashScreen({super.key});

  @override
  State<ShoeSplashScreen> createState() => _ShoeSplashScreenState();
}

class _ShoeSplashScreenState extends State<ShoeSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late Animation<Offset> _welcomeSlide;
  late Animation<double> _welcomeFontSize;

  late AnimationController _iconController;
  late Animation<Offset> _iconSlideAnimation;
  late Animation<double> _iconRotation;

  late AnimationController _buttonController;
  late Animation<Offset> _buttonSlide;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final String welcomeText = "Welcome";
  final String shopText = "Shoe Shop";

  @override
  void initState() {
    super.initState();

    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _welcomeSlide = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -3),
    ).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeInOut),
    );

    _welcomeFontSize = Tween<double>(begin: 55, end: 35).animate(
      CurvedAnimation(parent: _welcomeController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _iconSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeOut));

    _iconRotation = Tween<double>(begin: -0.5, end: 0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );

    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startShopTyping();
      }
    });

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _startWelcomeTyping();
  }

  void _startWelcomeTyping() {
    final provider = Provider.of<SplashProvider>(context, listen: false);
    provider.startWelcomeTyping(welcomeText, () {
      _welcomeController.forward().whenComplete(() {
        provider.setShowIconAndText();
        _fadeController.forward();
        _iconController.forward();
      });
    });
  }

  void _startShopTyping() {
    final provider = Provider.of<SplashProvider>(context, listen: false);
    provider.startShopTyping(shopText, () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _iconController.dispose();
    _buttonController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF093949),
      body: Stack(
        children: [
          // Welcome animated text
          Center(
            child: SlideTransition(
              position: _welcomeSlide,
              child: AnimatedBuilder(
                animation: _welcomeFontSize,
                builder:
                    (context, child) => Consumer<SplashProvider>(
                      builder:
                          (context, provider, _) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                provider.welcomeAnimatedLetters.map((letter) {
                                  return Transform.scale(
                                    scale: _welcomeFontSize.value / 52,
                                    child: letter,
                                  );
                                }).toList(),
                          ),
                    ),
              ),
            ),
          ),

          // Shoe image fade
          Consumer<SplashProvider>(
            builder: (context, provider, _) {
              if (!provider.showIconAndText) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Hero(
                    tag: 'shoeHero',
                    child: Image.asset(
                      'assets/images/high-heels.png',
                      height: 150,
                    ),
                  ),
                ),
              );
            },
          ),

          // Icon + Shoe Shop animated text
          Consumer<SplashProvider>(
            builder: (context, provider, _) {
              if (!provider.showIconAndText) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _iconSlideAnimation,
                        child: RotationTransition(
                          turns: _iconRotation,
                          child: Image.asset(
                            'assets/images/tennis-shoe-icon-56.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: provider.shopAnimatedLetters,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _buttonSlide,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 40.0,
                  left: 25,
                  right: 25,
                ),
                child: MyButton(
                  onPressed: () {
                     // Reset state before navigating away
                    Provider.of<SplashProvider>(context, listen: false).reset();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder: (_, __, ___) => const LoginOrRegister(),
                      ),
                    );
                  },
                  text: 'Start Shopping!',
                  width: double.infinity,
                  height: 60,
                  color: const Color(0xFFD5A983),
                  textcolor: const Color.fromARGB(255, 53, 40, 28),
                  icon: Icons.shopify,
                  iconColor: const Color.fromARGB(255, 53, 40, 28),
                  fontsize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
