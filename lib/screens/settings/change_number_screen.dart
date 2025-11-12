import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/update/update_contributor_request.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/models/responses/exception_response.dart';
import 'package:m3fund_flutter/services/user_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _choosenCountryCode;
  String? _initialCountryCode;
  String _error = "";
  bool _errorOccured = false;
  bool _isLoading = false;
  Key _phoneKey = UniqueKey();
  bool _isValidNumber = false;
  String? _pastNumber;

  final UserService _userService = UserService();

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Future<void> _loadUserInfo() async {
    ContributorResponse loadedUser = await _userService.me();
    setState(() {
      _pastNumber = loadedUser.phone;
      final phone = PhoneNumber.fromCompleteNumber(
        completeNumber: loadedUser.phone,
      );
      _phoneController.text = phone.number;
      _choosenCountryCode = "+${phone.countryCode}";
      _initialCountryCode = phone.countryISOCode;
      _phoneKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                toolbarHeight: 50,
                leadingWidth: 50,
                centerTitle: true,
                title: Text(
                  "Changez votre numéro de téléphone",
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
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                  ),
                  child: IntlPhoneField(
                    key: _phoneKey,
                    controller: _phoneController,
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
                          borderSide: BorderSide(color: primaryColor, width: 2),
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Numéro de téléphone',
                      labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
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
                    initialCountryCode: _initialCountryCode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (phone) {
                      setState(() {
                        _choosenCountryCode = phone.countryCode;
                        try {
                          _isValidNumber =
                              phone.isValidNumber() &&
                              phone.completeNumber != _pastNumber;
                        } catch (e) {
                          _isValidNumber = false;
                        }
                      });
                    },
                    onTap: () {
                      setState(() {
                        _errorOccured = false;
                      });
                    },
                  ),
                ),
              ),
            ],
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
            onPressed: _isLoading || !_isValidNumber
                ? null
                : () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      var user = await _userService.patchUser(
                        contributor: UpdateContributorRequest(
                          phone: "$_choosenCountryCode${_phoneController.text}",
                        ),
                      );
                      _loadUserInfo();
                      setState(() {
                        _isLoading = false;
                        _pastNumber = user.phone;
                        _isValidNumber = false;
                      });
                      showCustomTopSnackBar(
                        context,
                        "Numéro changé avec succès",
                      );
                    } catch (e) {
                      ExceptionResponse exception = ExceptionResponse.fromJson(
                        jsonDecode(e.toString().replaceAll("Exception: ", "")),
                      );
                      setState(() {
                        _error = exception.message;
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
    );
  }
}
