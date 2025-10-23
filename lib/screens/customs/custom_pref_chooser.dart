import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/tools/user_prefs_manager.dart';
import 'package:remixicon/remixicon.dart';

class CustomPrefChooser extends StatefulWidget {
  final IconData icon;
  final String text;
  final dynamic prefType;
  const CustomPrefChooser({
    super.key,
    required this.icon,
    required this.text,
    required this.prefType,
  });

  @override
  State<CustomPrefChooser> createState() => _CustomPrefChooserState();
}

class _CustomPrefChooserState extends State<CustomPrefChooser> {
  final UserPrefsManager _userPrefsManager = UserPrefsManager();
  bool _isChoosen = false;

  @override
  void initState() {
    setState(() {
      _isChoosen = _userPrefsManager.isSelected(widget.prefType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_isChoosen) {
                if (widget.prefType is CampaignType) {
                  _userPrefsManager.removeCampaignPref(widget.prefType);
                } else {
                  _userPrefsManager.removeDomainPref(widget.prefType);
                }
              } else {
                if (widget.prefType is CampaignType) {
                  _userPrefsManager.addCampaignPref(widget.prefType);
                } else {
                  _userPrefsManager.addDomainPref(widget.prefType);
                }
              }
              _isChoosen = !_isChoosen;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _isChoosen ? secondaryColor : f4Grey,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      _isChoosen ? RemixIcons.check_line : widget.icon,
                      size: 24,
                      color: _isChoosen
                          ? Colors.white
                          : Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: _isChoosen ? Colors.white : Colors.black,
                      ),
                    ),
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
