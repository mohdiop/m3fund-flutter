import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBlurDialog extends StatefulWidget {
  final Widget child;
  const CustomBlurDialog({super.key, required this.child});

  @override
  State<CustomBlurDialog> createState() => _CustomBlurDialogState();
}

class _CustomBlurDialogState extends State<CustomBlurDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withValues(alpha: 0.3),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
