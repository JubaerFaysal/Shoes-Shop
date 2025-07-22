import 'package:flutter/material.dart';
import 'package:shoes_business/Methods/animated_letter.dart';

class SplashProvider extends ChangeNotifier {
  final List<Widget> welcomeAnimatedLetters = [];
  final List<Widget> shopAnimatedLetters = [];

  bool _showIconAndText = false;
  bool get showIconAndText => _showIconAndText;

  void startWelcomeTyping(String text, VoidCallback onComplete) {
    const durationPerLetter = Duration(milliseconds: 120);
    for (int i = 0; i < text.length; i++) {
      Future.delayed(durationPerLetter * i, () {
        welcomeAnimatedLetters.add(AnimatedLetter(char: text[i],));
        notifyListeners();

        if (i == text.length - 1) {
          Future.delayed(const Duration(milliseconds: 400), onComplete);
        }
      });
    }
  }

  void startShopTyping(String text, VoidCallback onComplete) {
    const durationPerLetter = Duration(milliseconds: 100);
    for (int i = 0; i < text.length; i++) {
      Future.delayed(durationPerLetter * i, () {
        shopAnimatedLetters.add(AnimatedLetter(char: text[i]));
        notifyListeners();

        if (i == text.length - 1) {
          Future.delayed(const Duration(milliseconds: 400), onComplete);
        }
      });
    }
  }

   void reset() {
    welcomeAnimatedLetters.clear();
    shopAnimatedLetters.clear();
    _showIconAndText = false;
    notifyListeners();
  }

 void setShowIconAndText() {
    _showIconAndText = true;
    notifyListeners();
  }


}
