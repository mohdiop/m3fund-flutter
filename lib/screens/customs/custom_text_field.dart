import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class CustomTextField extends StatefulWidget {
  final Icon? icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final double width;
  const CustomTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.width,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(fontSize: 12),
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          prefixIconConstraints: BoxConstraints(
            minHeight: widget.icon != null ? 50 : 0,
            minWidth: widget.icon != null ? 50 : 0,
          ),
          prefixIcon: widget.icon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: widget.icon,
                )
              : SizedBox(width: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF2D2D2D), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF06A664), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 23,
            horizontal: 0,
          ),
          suffixIconConstraints: BoxConstraints(minHeight: 50, minWidth: 50),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? RemixIcons.eye_off_line
                        : RemixIcons.eye_line,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        cursorColor: const Color(0xFF06A664),
      ),
    );
  }
}
