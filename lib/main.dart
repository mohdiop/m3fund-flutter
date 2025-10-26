import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/launcher/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool("isFirstTime") ?? true;
  final isAuthenticated = prefs.getBool("isAuthenticated");
  if (isAuthenticated == null) {
    await prefs.setBool("isAuthenticated", false);
  }
  runApp(
    MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: primaryColor,
          cursorColor: Colors.white,
          selectionHandleColor: primaryColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      home: SplashScreen(
        isFirstTime: isFirstTime,
        isAuthenticated: isAuthenticated ?? false,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
