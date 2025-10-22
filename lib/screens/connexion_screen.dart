import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  Future<void> _setIsFirstTimeToFalse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isFirstTime", false);
  }

  @override
  void initState() {
    super.initState();
    _setIsFirstTimeToFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/logoName.png", width: 221),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  fixedSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 3,
                ),
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continuer sans se connecter",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 25),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(
                          RemixIcons.arrow_right_line,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 43),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Connexion",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
