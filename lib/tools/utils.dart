import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';

void showBlurDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String closureText,
  required String actionText,
  required IconData icon,
  required Future<void> Function() action,
  required ValueNotifier<bool> isLoading,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: title,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, child) {
          return Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withValues(alpha: 0)),
              ),
              Center(
                child: Dialog(
                  elevation: 0,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 44, color: primaryColor),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(content, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  isLoading.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  backgroundColor: f4Grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  closureText,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: value
                                    ? null
                                    : () async {
                                        isLoading.value = true;
                                        await action();
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: value
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                          backgroundColor: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        actionText,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(opacity: anim, child: child);
    },
  );
}
