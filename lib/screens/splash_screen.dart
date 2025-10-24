import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3fund_flutter/screens/main_screen.dart';
import 'package:m3fund_flutter/screens/login_screen.dart';
import 'package:m3fund_flutter/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isFirstTime;
  final bool isAuthenticated;

  const SplashScreen({
    super.key,
    required this.isFirstTime,
    required this.isAuthenticated,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    if (widget.isAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } else if (widget.isFirstTime) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => OnboardingScreen()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/logoName.png", width: 221)],
        ),
      ),
    );
  }
}
