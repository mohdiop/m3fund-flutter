import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/update/update_contributor_request.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/models/responses/exception_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_text_field.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  String? _pastEmail;
  bool _isLoading = false;
  bool _errorOccured = false;
  String _error = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();
  final AuthenticationService _authenticationService = AuthenticationService();

  bool _isValidEmail = false;

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Future<void> _loadUserInfo() async {
    ContributorResponse loadedUser = await _userService.me();
    setState(() {
      _pastEmail = loadedUser.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 50,
                  leadingWidth: 50,
                  centerTitle: true,
                  title: Text(
                    "Changez votre émail",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),

                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(
                        RemixIcons.arrow_left_line,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Text(
                "Cette action requiert une authentification, confirmez votre mot de passe pour continuer.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Votre émail actuel est ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  children: [
                    TextSpan(
                      text: "$_pastEmail",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomTextField(
              icon: Icon(RemixIcons.mail_line),
              hintText: "Nouveau email",
              isPassword: false,
              controller: _emailController,
              width: 300,
              onChange: (value) {
                if (value != null) {
                  setState(() {
                    _isValidEmail =
                        value != _pastEmail &&
                        validateEmail(value) &&
                        _passwordController.text.trim().isNotEmpty;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            CustomTextField(
              icon: Icon(RemixIcons.lock_2_line),
              hintText: "Confirmer votre mot de passe",
              isPassword: true,
              controller: _passwordController,
              width: 300,
              onChange: (value) {
                if (value != null) {
                  setState(() {
                    _isValidEmail =
                        value.trim().isNotEmpty &&
                        _emailController.text.trim() != _pastEmail &&
                        validateEmail(_emailController.text.trim());
                  });
                }
              },
            ),

            SizedBox(height: 20),
            if (_errorOccured)
              SizedBox(
                width: 300,
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_errorOccured) SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading || !_isValidEmail
                  ? null
                  : () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        await _authenticationService.login(
                          authenticationRequest: AuthenticationRequest(
                            email: _pastEmail!,
                            password: _passwordController.text.trim(),
                          ),
                        );
                        var user = await _userService.patchUser(
                          contributor: UpdateContributorRequest(
                            email: _emailController.text,
                          ),
                        );
                        _loadUserInfo();
                        setState(() {
                          _isLoading = false;
                          _pastEmail = user.email;
                          _isValidEmail = false;
                          _passwordController.text = "";
                          _emailController.text = "";
                          _errorOccured = false;
                        });
                        showCustomTopSnackBar(
                          context,
                          "Email changé avec succès",
                        );
                      } catch (e) {
                        ExceptionResponse exception =
                            ExceptionResponse.fromJson(
                              jsonDecode(
                                e.toString().replaceAll("Exception: ", ""),
                              ),
                            );
                        setState(() {
                          if (exception.code == "BAD_CREDENTIALS") {
                            _error = "Mot de passe incorrect";
                          } else {
                            _error = exception.message;
                          }
                          _errorOccured = true;
                          _isLoading = false;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.white : primaryColor,
                foregroundColor: Colors.white,
                fixedSize: Size(300, 54),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? SpinKitSpinningLines(color: primaryColor, size: 32)
                  : Text("Modifier", style: const TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}
