import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_contributor_request.dart';
import 'package:m3fund_flutter/models/responses/exception_response.dart';
import 'package:m3fund_flutter/screens/auth/profile_picture_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_text_field.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _scrollController = ScrollController();

  String _choosenCountryCode = "+223";

  final AuthenticationService _authenticationService = AuthenticationService();

  bool _showError = false;
  String _currentError = "";
  bool _isLoading = false;

  bool _areBlankFileds() {
    return _firstNameController.text.trim().isEmpty &&
        _lastNameController.text.trim().isEmpty &&
        _phoneNumberController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty &&
        _confirmPasswordController.text.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Center(
                child: Column(
                  children: [
                    Image.asset("assets/logoName.png", width: 221),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Inscription",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                          icon: Icon(RemixIcons.user_3_line),
                          hintText: "Prénom",
                          isPassword: false,
                          controller: _firstNameController,
                          width: 169,
                        ),
                        CustomTextField(
                          icon: null,
                          hintText: "Nom",
                          isPassword: false,
                          controller: _lastNameController,
                          width: 121,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dialogTheme: DialogThemeData(
                                backgroundColor: Colors.white,
                              ),
                            ),
                            child: IntlPhoneField(
                              controller: _phoneNumberController,
                              style: TextStyle(fontSize: 12),
                              cursorColor: primaryColor,
                              languageCode: "FR",
                              pickerDialogStyle: PickerDialogStyle(
                                searchFieldCursorColor: primaryColor,
                                searchFieldInputDecoration: InputDecoration(
                                  hint: Text(
                                    "Rechercher votre pays ici ...",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  focusColor: primaryColor,
                                  fillColor: primaryColor,
                                  prefixIcon: Icon(RemixIcons.search_2_line),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(
                                      color: customBlackColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Numéro de téléphone',
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2D2D2D),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF06A664),
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                  horizontal: 0,
                                ),
                              ),
                              initialCountryCode: 'ML',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (phone) {
                                setState(() {
                                  _choosenCountryCode = phone.countryCode;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      icon: Icon(RemixIcons.mail_line),
                      hintText: "Email",
                      isPassword: false,
                      controller: _emailController,
                      width: 300,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      icon: Icon(RemixIcons.lock_2_line),
                      hintText: "Mot de passe",
                      isPassword: true,
                      controller: _passwordController,
                      width: 300,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      icon: Icon(RemixIcons.lock_2_line),
                      hintText: "Confirmer le mot de passe",
                      isPassword: true,
                      controller: _confirmPasswordController,
                      width: 300,
                    ),
                    if (_showError)
                      Column(
                        children: [
                          SizedBox(height: 5),
                          SizedBox(
                            width: 280,
                            child: Text(
                              _currentError,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading ? f4Grey : primaryColor,
                        foregroundColor: Colors.white,
                        fixedSize: Size(300, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? SpinKitSpinningLines(color: primaryColor, size: 32)
                          : Text("Continuer", style: TextStyle(fontSize: 24)),
                      onPressed: () async {
                        if (_areBlankFileds()) {
                          setState(() {
                            _currentError =
                                "Veuillez remplir tous les champs obligatoires.";
                            _showError = true;
                          });
                        } else if (!validatePassword(
                          _passwordController.text.trim(),
                        )) {
                          setState(() {
                            _currentError =
                                "Choisissez un mot de passe robuste, il doit contenir entre 8 à 64 caractères, au moins une majuscule, une minuscule, un chiffre et un caractère spécial.";
                            _showError = true;
                          });
                        } else if (_passwordController.text.trim() !=
                            _confirmPasswordController.text.trim()) {
                          setState(() {
                            _currentError =
                                "Les mots de passe ne matchent pas.";
                            _showError = true;
                          });
                        } else if (_emailController.text.trim().isEmpty &&
                            !validateEmail(_emailController.text.trim())) {
                          setState(() {
                            _currentError =
                                "Format d'email invalide, ex: example@example.com.";
                            _showError = true;
                          });
                        } else {
                          setState(() {
                            _showError = false;
                          });
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await _authenticationService
                                .checkForEmailAndPhoneValidity(
                                  email: _emailController.text.trim(),
                                  phone:
                                      "$_choosenCountryCode${_phoneNumberController.text.trim()}",
                                );
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfilePictureScreen(
                                    contributorRequest: CreateContributorRequest(
                                      firstName: _firstNameController.text
                                          .trim(),
                                      lastName: _lastNameController.text.trim(),
                                      localization: null,
                                      projectDomainPrefs: [],
                                      campaignTypePrefs: [],
                                      email: _emailController.text.trim(),
                                      phone:
                                          "$_choosenCountryCode${_phoneNumberController.text.trim()}",
                                      password: _passwordController.text.trim(),
                                    ),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            setState(() {
                              ExceptionResponse exception =
                                  ExceptionResponse.fromJson(
                                    jsonDecode(
                                      e.toString().replaceAll(
                                        "Exception: ",
                                        "",
                                      ),
                                    ),
                                  );
                              _currentError = exception.message;
                              _showError = true;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vous avez déjà un compte? ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Se connecter.",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
