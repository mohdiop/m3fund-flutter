import 'package:flutter/material.dart';
import 'package:m3fund_flutter/screens/customs/custom_request_auth_page.dart';

class StatsScreen extends StatefulWidget {
  final bool isAuthenticated;
  const StatsScreen({super.key, required this.isAuthenticated});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.isAuthenticated
        ? Scaffold(body: Center(child: Text("Stats Screen")))
        : CustomRequestAuthPage(sectionName: "Statistiques");
  }
}
