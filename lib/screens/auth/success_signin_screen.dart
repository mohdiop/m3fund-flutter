import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/home/main_screen.dart';

class SuccessSigninScreen extends StatefulWidget {
  const SuccessSigninScreen({super.key});

  @override
  State<SuccessSigninScreen> createState() => _SuccessSigninScreenState();
}

class _SuccessSigninScreenState extends State<SuccessSigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: 20,
            children: [
              SizedBox(height: 100),
              Text("Vous êtes inscrits", style: TextStyle(fontSize: 24)),
              Center(child: Image.asset("assets/success.png", width: 250)),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              fixedSize: Size(300, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Continuer vers l'accueil",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (_) => false,
              );
            },
          ),
        ),
      ),
    );
  }
}
