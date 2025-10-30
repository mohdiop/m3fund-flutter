import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/launcher/splash_screen.dart';
import 'package:m3fund_flutter/screens/transition/fade_slide_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
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
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeSlideTransition(),
            TargetPlatform.iOS: FadeSlideTransition(),
            TargetPlatform.linux: FadeSlideTransition(),
            TargetPlatform.macOS: FadeSlideTransition(),
            TargetPlatform.windows: FadeSlideTransition(),
            TargetPlatform.fuchsia: FadeSlideTransition(),
          },
        ),
      ),
      builder: (context, child) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 10 && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: child,
        );
      },
      home: SplashScreen(
        isFirstTime: isFirstTime,
        isAuthenticated: isAuthenticated ?? false,
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
    ),
  );
}
