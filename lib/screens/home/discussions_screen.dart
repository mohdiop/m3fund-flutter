import 'package:flutter/material.dart';
import 'package:m3fund_flutter/screens/customs/custom_request_auth_page.dart';

class DiscussionsScreen extends StatefulWidget {
  final bool isAuthenticated;
  const DiscussionsScreen({super.key, required this.isAuthenticated});

  @override
  State<DiscussionsScreen> createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.isAuthenticated
        ? Scaffold(body: Center(child: Text("Discussions Screen")))
        : CustomRequestAuthPage(sectionName: "Discussions",);
  }
}
