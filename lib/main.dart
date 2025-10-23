import 'package:flutter/material.dart';
import 'package:m3fund_flutter/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool("isFirstTime") ?? true;
  runApp(
    MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0xFF06A664),
          cursorColor: Colors.white,
          selectionHandleColor: Color(0xFF06A664),
        ),
      ),
      home: SplashScreen(isFirstTime: isFirstTime),
      debugShowCheckedModeBanner: false,
    ),
  );
}
