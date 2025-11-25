import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';

class CustomSubMenu extends StatefulWidget {
  final IconData leftIcon;
  final IconData rightIcon;
  final String menuTitle;
  const CustomSubMenu({
    super.key,
    required this.leftIcon,
    required this.rightIcon,
    required this.menuTitle,
  });

  @override
  State<CustomSubMenu> createState() => _CustomSubMenuState();
}

class _CustomSubMenuState extends State<CustomSubMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: f4Grey,
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.leftIcon),
            SizedBox(
              width: 245,
              child: Text(widget.menuTitle, style: TextStyle(fontSize: 16)),
            ),
            Icon(widget.rightIcon),
          ],
        ),
      ),
    );
  }
}
