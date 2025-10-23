import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/responses/exception_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_text_field.dart';
import 'package:m3fund_flutter/screens/home_screen.dart';
import 'package:m3fund_flutter/screens/signin_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:remixicon/remixicon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showError = false;
  String _currentError = "";

  bool areBlankFields() {
    return (_usernameController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        thumbVisibility: false,
        trackVisibility: false,
        thickness: 0,
        child: SingleChildScrollView(
          child: Padding(
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
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
                  SizedBox(
                    width: 300,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Téléphone (avec indicatif) ou email",
                    icon: Icon(
                      RemixIcons.user_3_line,
                      size: 24,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    isPassword: false,
                    controller: _usernameController,
                    width: 300,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    icon: Icon(
                      RemixIcons.lock_2_line,
                      size: 24,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    hintText: "Mot de passe",
                    isPassword: true,
                    controller: _passwordController,
                    width: 300,
                  ),
                  SizedBox(height: 8),
                  if (_showError)
                    Column(
                      children: [
                        SizedBox(
                          width: 280,
                          child: Text(
                            _currentError,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  SizedBox(
                    width: 280,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Mot de passe oublié?",
                          style: TextStyle(color: secondaryColor, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: Size(300, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Se connecter", style: TextStyle(fontSize: 24)),
                    onPressed: () async {
                      if (areBlankFields()) {
                        setState(() {
                          _currentError = "Veuillez remplir tous les champs";
                          _showError = true;
                        });
                      } else {
                        setState(() {
                          _showError = false;
                        });
                        try {
                          await _authenticationService.login(
                            authenticationRequest: AuthenticationRequest(
                              email: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                              (Route<dynamic> route) =>
                                  false, // ✅ supprime toutes les routes précédentes
                            );
                          }
                        } catch (e) {
                          setState(() {
                            ExceptionResponse exception =
                                ExceptionResponse.fromJson(
                                  jsonDecode(
                                    e.toString().replaceAll("Exception: ", ""),
                                  ),
                                );
                            _currentError = exception.message;
                            _showError = true;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "ou",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      fixedSize: Size(300, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xFF2D2D2D), width: 2),
                      ),
                    ),
                    child: Text("S'inscrire", style: TextStyle(fontSize: 24)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SigninScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
