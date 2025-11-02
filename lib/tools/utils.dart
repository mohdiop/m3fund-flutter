import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/exception_response.dart';
import 'package:m3fund_flutter/models/responses/payment_response.dart';
import 'package:m3fund_flutter/models/responses/project_response.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:m3fund_flutter/screens/auth/signin_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/screens/home/main_screen.dart';
import 'package:m3fund_flutter/services/volunteering_service.dart';
import 'package:remixicon/remixicon.dart';

void showBlurLocalizationDialog({
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
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                                        child: SpinKitSpinningLines(
                                          color: primaryColor,
                                          size: 28,
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

void showBlurDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String leftButtonText,
  required String rightButtonText,
  IconData? icon,
  required Future<void> Function() rightButtonAction,
  required Future<void> Function() leftButtonAction,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: title,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(color: Colors.black.withValues(alpha: 0)),
            ),
          ),
          Center(
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (icon != null) const SizedBox(height: 15),
                    if (icon != null) Icon(icon, size: 44, color: primaryColor),
                    const SizedBox(height: 10),
                    Text(content, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () async {
                              await leftButtonAction();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: customBlackColor,
                              backgroundColor: f4Grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              leftButtonText,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () async {
                              await rightButtonAction();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: customBlackColor,
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              rightButtonText,
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
}

showRequestConnectionDialog(BuildContext context) {
  showBlurDialog(
    context: context,
    title: "Connexion Requise",
    content: "Pour accéder à cette section, vous devez être connecté.",
    leftButtonText: "Inscription",
    rightButtonText: "Connexion",
    icon: LineAwesomeIcons.user_slash_solid,
    leftButtonAction: () async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SigninScreen()),
        (_) => false,
      );
    },
    rightButtonAction: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    },
  );
}

void showConfirmContributionDialog({
  required BuildContext context,
  required int campaignId,
  required VolunteeringService volunteeringService,
  required ValueNotifier<bool> isLoading,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Contribution",
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
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
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
                        Icon(
                          RemixIcons.shake_hands_fill,
                          size: 44,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Contribution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Voulez-vous contribuer à ce projet? Le porteur du projet vous contactera.",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          spacing: 20,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
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
                                  "Annuler",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: value
                                    ? null
                                    : () async {
                                        isLoading.value = true;
                                        try {
                                          await volunteeringService
                                              .createVolunteering(campaignId);
                                          if (context.mounted) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MainScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        } catch (e) {
                                          if (e.toString().startsWith(
                                            "Exception: {",
                                          )) {
                                            ExceptionResponse exception =
                                                ExceptionResponse.fromJson(
                                                  jsonDecode(
                                                        e
                                                            .toString()
                                                            .replaceFirst(
                                                              "Exception: ",
                                                              "",
                                                            ),
                                                      )
                                                      as Map<String, dynamic>,
                                                );
                                            showCustomTopSnackBar(
                                              context,
                                              exception.message,
                                              color: Colors.redAccent,
                                            );
                                          } else {
                                            showCustomTopSnackBar(
                                              context,
                                              e.toString(),
                                              color: Colors.redAccent,
                                            );
                                          }

                                          isLoading.value = false;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: isLoading.value
                                      ? Colors.white
                                      : primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: value
                                    ? SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: SpinKitSpinningLines(
                                          color: primaryColor,
                                          size: 28,
                                        ),
                                      )
                                    : Text(
                                        "Oui",
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

Future<void> showCustomTopSnackBar(
  BuildContext context,
  String message, {
  Color? color = primaryColor,
}) async {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  HapticFeedback.mediumImpact();
  final controller = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );

  final animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut,
  );

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: FadeTransition(
        opacity: animation,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  controller.forward();

  Future.delayed(const Duration(seconds: 4), () async {
    await controller.reverse;
    entry.remove();
    controller.dispose();
  });
}

showLogoutDialog(BuildContext context, Future<void> Function() logout) {
  showBlurDialog(
    context: context,
    title: "Déconnexion",
    content: "Êtes-vous sûr de vouloir vous déconnecter?.",
    leftButtonText: "Annuler",
    rightButtonText: "Oui",
    icon: RemixIcons.logout_circle_r_line,
    leftButtonAction: () async {
      Navigator.pop(context);
    },
    rightButtonAction: () async {
      await logout();
    },
  );
}

bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool validatePassword(String password) {
  final RegExp passwordRegex = RegExp(
    "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@\$!%*?&]).{8,64}\$",
  );
  return passwordRegex.hasMatch(password);
}

List<Map<String, dynamic>> summarizeLastFiveMonths(List<PaymentResponse> payments) {
  final now = DateTime.now();

  // Créer une map pour stocker les montants par mois
  Map<int, double> monthTotals = {};

  // Obtenir les 5 derniers mois (y compris le mois courant)
  List<int> lastFiveMonths = List.generate(5, (i) => (now.month - i - 1 + 12) % 12 + 1);

  // Initialiser les montants à 0
  for (var month in lastFiveMonths) {
    monthTotals[month] = 0.0;
  }

  // Filtrer et sommer les paiements pour ces mois
  for (var payment in payments) {
    final month = payment.madeAt.month;
    if (monthTotals.containsKey(month)) {
      monthTotals[month] = monthTotals[month]! + payment.amount;
    }
  }

  // Calculer le montant total sur les 5 mois
  final totalAmount = monthTotals.values.fold(0.0, (sum, amt) => sum + amt);

  // Liste des noms des mois en français
  const monthNames = [
    '', // placeholder pour index 0
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];

  // Construire le résultat
  List<Map<String, dynamic>> result = lastFiveMonths.reversed.map((month) {
    final amount = monthTotals[month] ?? 0.0;
    final percentage = totalAmount > 0 ? (amount / totalAmount) * 100 : 0.0;
    return {
      'mois': monthNames[month],
      'val': double.parse(percentage.toStringAsFixed(1)), // arrondi à 1 décimale
      'amount': amount,
    };
  }).toList();

  return result;
}

List<Map<String, dynamic>> generateProjectDomainStats(
    List<ProjectResponse> projects) {
  if (projects.isEmpty) return [];

  // Étape 1: Compter les occurrences de chaque domaine
  final Map<ProjectDomain, int> domainCount = {};
  for (var project in projects) {
    domainCount[project.domain] = (domainCount[project.domain] ?? 0) + 1;
  }

  // Étape 2: Calculer le total
  final int total = projects.length;

  // Étape 3: Associer un label et une couleur à chaque domaine
  final Map<ProjectDomain, Map<String, dynamic>> domainMeta = {
    ProjectDomain.education: {
      'label': 'Éducation',
      'color': Colors.teal,
    },
    ProjectDomain.health: {
      'label': 'Santé',
      'color': Colors.lightBlue,
    },
    ProjectDomain.agriculture: {
      'label': 'Agriculture',
      'color': Colors.orange,
    },
    ProjectDomain.breeding: {
      'label': 'Élevage',
      'color': Colors.brown,
    },
    ProjectDomain.mine: {
      'label': 'Mine',
      'color': Colors.grey,
    },
    ProjectDomain.culture: {
      'label': 'Culture',
      'color': Colors.purple,
    },
    ProjectDomain.environment: {
      'label': 'Environnement',
      'color': Colors.green,
    },
    ProjectDomain.computerScience: {
      'label': 'Informatique',
      'color': Colors.blueGrey,
    },
    ProjectDomain.solidarity: {
      'label': 'Solidarité',
      'color': Colors.pink,
    },
    ProjectDomain.shopping: {
      'label': 'Commerce',
      'color': Colors.amber,
    },
    ProjectDomain.social: {
      'label': 'Social',
      'color': Colors.redAccent,
    },
  };

  // Étape 4: Construire la liste de données
  final List<Map<String, dynamic>> data = domainCount.entries.map((entry) {
    final domain = entry.key;
    final count = entry.value;
    final meta = domainMeta[domain];

    return {
      'label': meta?['label'] ?? domain.toString(),
      'value': (count / total) * 100,
      'color': meta?['color'] ?? Colors.grey,
    };
  }).toList();

  return data;
}
