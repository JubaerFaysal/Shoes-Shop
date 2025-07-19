import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shoes_business/Authetication/login_or_register.dart';
import 'package:shoes_business/components/my_button.dart';

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

  bool _showIconAndText = false;

  final String welcomeText = "Welcome";
  final String shopText = "Shoe Shop";

  List<Widget> welcomeAnimatedLetters = [];
  List<Widget> shopAnimatedLetters = [];

  @override
  void initState() {
    super.initState();

    _startWelcomeTyping();

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
  }

  void _startWelcomeTyping() {
    const durationPerLetter = Duration(milliseconds: 120);
    for (int i = 0; i < welcomeText.length; i++) {
      Future.delayed(durationPerLetter * i, () {
        setState(() {
          welcomeAnimatedLetters.add(AnimatedLetter(char: welcomeText[i]));
        });
        if (i == welcomeText.length - 1) {
          Future.delayed(const Duration(milliseconds: 400), () {
            _welcomeController.forward().whenComplete(() {
              setState(() => _showIconAndText = true);
              _fadeController.forward();
              _iconController.forward();
            });
          });
        }
      });
    }
  }

  void _startShopTyping() {
    const durationPerLetter = Duration(milliseconds: 100);
    for (int i = 0; i < shopText.length; i++) {
      Future.delayed(durationPerLetter * i, () {
        setState(() {
          shopAnimatedLetters.add(AnimatedLetter(char: shopText[i]));
        });
        if (i == shopText.length - 1) {
          Future.delayed(const Duration(milliseconds: 400), () {
            _buttonController.forward();
          });
        }
      });
    }
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
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          // Welcome animated text
          Center(
            child: SlideTransition(
              position: _welcomeSlide,
              child: AnimatedBuilder(
                animation: _welcomeFontSize,
                builder:
                    (context, child) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          welcomeAnimatedLetters.map((letter) {
                            return Transform.scale(
                              scale: _welcomeFontSize.value / 52,
                              child: letter,
                            );
                          }).toList(),
                    ),
              ),
            ),
          ),
      
          // Shoe Hero Image with fade
          if (_showIconAndText)
            Align(
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
            ),
      
          // Icon + Shoe Shop animated text
          if (_showIconAndText)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 240),
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
                      children: shopAnimatedLetters,
                    ),
                  ],
                ),
              ),
            ),
      
          // Buttons from bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _buttonSlide,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0,left: 25,right: 25),
                child: MyButton(
                  onPressed: () {
                   Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(
                          milliseconds: 800,
                        ), // <-- slower transition
                        pageBuilder:
                            (_, __, ___) => LoginOrRegister()
                      ),
                    );

                  },
                  text: 'Start Shopping!',
                  width: double.infinity,
                  height: 60,
                  color: Colors.tealAccent,
                  textcolor: Colors.black54,
                  icon: Icons.shopify,
                  iconColor: Colors.black54,
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

// Letter animation widget
class AnimatedLetter extends StatefulWidget {
  final String char;

  const AnimatedLetter({super.key, required this.char});

  @override
  State<AnimatedLetter> createState() => _AnimatedLetterState();
}

class _AnimatedLetterState extends State<AnimatedLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Text(
          widget.char,
          style: const TextStyle(
            fontSize: 52,
            fontFamily: 'Yesteryear',
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
