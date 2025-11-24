import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/notification_response.dart';
import 'package:m3fund_flutter/screens/home/main_screen.dart';
import 'package:m3fund_flutter/services/notification_service.dart';
import 'package:m3fund_flutter/tools/notification_read_storage.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  final NotificationReadStorage _readStorage =
      NotificationReadStorage.instance;

  List<NotificationResponse> _notifications = [];
  Set<int> _readNotificationIds = {};
  bool _isLoading = true;
  String? _errorMessage;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final storedIds = await _readStorage.loadReadIds();
    if (!mounted) return;
    setState(() {
      _readNotificationIds = storedIds;
    });
    await _refreshNotifications(showLoader: true);
  }

  Future<void> _refreshNotifications({bool showLoader = false}) async {
    if (showLoader || _notifications.isEmpty) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }

    try {
      final notifications = await _notificationService.getMyNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = notifications
            .map(
              (notification) => _readNotificationIds.contains(notification.id)
                  ? notification.copyWith(isRead: true)
                  : notification,
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      await showCustomTopSnackBar(
        context,
        "Impossible de charger les notifications pour le moment.",
      );
      setState(() {
        _errorMessage =
            "Impossible de charger les notifications pour le moment.";
        _isLoading = false;
      });
    }
  }

  Future<void> _markNotificationAsRead(int index) async {
    final notification = _notifications[index];
    if (notification.isRead) return;

    final updatedNotifications = [..._notifications];
    updatedNotifications[index] = notification.copyWith(isRead: true);
    final updatedIds = {..._readNotificationIds, notification.id};

    setState(() {
      _notifications = updatedNotifications;
      _readNotificationIds = updatedIds;
    });

    await _readStorage.saveReadIds(updatedIds);
  }

  Color _typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.newMessage:
        return Colors.blueAccent;
      case NotificationType.newContribution:
        return primaryColor;
      case NotificationType.newComment:
        return Colors.deepPurpleAccent;
      case NotificationType.projectValidated:
        return Colors.green;
      case NotificationType.projectRejected:
        return Colors.redAccent;
      case NotificationType.targetBudgetReached:
        return secondaryColor;
      case NotificationType.campaignFinished:
        return Colors.teal;
      case NotificationType.systemAlert:
        return Colors.orangeAccent;
    }
  }

  String _senderInitials(String sender) {
    final cleaned = sender.trim();
    if (cleaned.isEmpty) return "??";
    final parts = cleaned.split(RegExp(r"\s+"));

    if (parts.length == 1) {
      final word = parts.first;
      if (word.isEmpty) return "??";
      if (word.length == 1) return word[0].toUpperCase();
      return (word[0] + word[1]).toUpperCase();
    }

    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    final initials = (first + last).trim();
    return initials.isEmpty ? "??" : initials.toUpperCase();
  }

  String _sectionLabel(DateTime date) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;
    return isToday ? "Aujourd'hui" : "Plutôt";
  }

  String _timeChipLabel(DateTime date) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;
    if (isToday) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return "${hour}h$minute";
    }

    final yesterday = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    final isYesterday = date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
    if (isYesterday) {
      return "Hier";
    }

    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                color: primaryColor,
                onRefresh: () => _refreshNotifications(),
                child: _buildNotificationsList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: customBlackColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Restez informé(e) de tout ce qui compte.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                RemixIcons.close_line,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    ListView buildStatefulList(List<Widget> children) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: children,
      );
    }

    if (_isLoading) {
      return buildStatefulList(const [
        SizedBox(height: 120),
        Center(child: CircularProgressIndicator(color: primaryColor)),
      ]);
    }

    if (_errorMessage != null) {
      return buildStatefulList([
        const SizedBox(height: 80),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]);
    }

    if (_notifications.isEmpty) {
      return buildStatefulList([
        const SizedBox(height: 80),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: f4Grey,
                ),
                child: const Icon(
                  RemixIcons.notification_off_line,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Aucune notification pour le moment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Vous serez notifié(e) dès qu'une nouvelle activité\nimportante sera disponible.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ]);
    }

    final sorted = [..._notifications]
      ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
    final Map<String, List<NotificationResponse>> grouped = {};
    final List<String> sectionOrder = [];

    for (final notification in sorted) {
      final label = _sectionLabel(notification.sentAt);
      if (!grouped.containsKey(label)) {
        grouped[label] = [];
        sectionOrder.add(label);
      }
      grouped[label]!.add(notification);
    }

    final List<Widget> children = [];
    for (final label in sectionOrder) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ),
      );

      final sectionItems = grouped[label]!;
      for (var i = 0; i < sectionItems.length; i++) {
        final notification = sectionItems[i];
        final originalIndex = _notifications
            .indexWhere((element) => element.id == notification.id);
        children.add(_buildNotificationTile(notification, originalIndex));
        children.add(
          i == sectionItems.length - 1
              ? const SizedBox(height: 10)
              : const Divider(height: 26),
        );
      }
    }

    return buildStatefulList(children);
  }

  Widget _buildNotificationTile(
      NotificationResponse notification, int originalIndex) {
    final typeColor = _typeColor(notification.type);
    final isRead = notification.isRead;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _markNotificationAsRead(originalIndex),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: typeColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  _senderInitials(notification.senderName),
                  style: TextStyle(
                    color: typeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isRead ? FontWeight.w500 : FontWeight.w700,
                      color: customBlackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _timeChipLabel(notification.sentAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 6),
                if (!isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFC53D),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          height: 90,
          width: double.infinity,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 68,
              width: 350,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(10),
                child: GNav(
                  gap: 5,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: customBlackColor,
                  curve: Curves.easeInCubic,
                  tabBorderRadius: 10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  iconSize: 28,
                  selectedIndex: _bottomNavIndex,
                  onTabChange: _handleBottomNavTap,
                  tabs: [
                    GButton(
                      icon: _bottomNavIndex == 0
                          ? RemixIcons.home_9_fill
                          : RemixIcons.home_9_line,
                      text: "Accueil",
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.white),
                       
                    ),
                    GButton(
                      icon: _bottomNavIndex == 1
                          ? RemixIcons.line_chart_fill
                          : RemixIcons.line_chart_line,
                      text: "Statistiques",
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    GButton(
                      icon: _bottomNavIndex == 2
                          ? RemixIcons.question_answer_fill
                          : RemixIcons.question_answer_line,
                      text: "Discussions",
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    GButton(
                      icon: _bottomNavIndex == 3
                          ? RemixIcons.settings_5_fill
                          : RemixIcons.settings_5_line,
                      text: "Paramètres",
                      textStyle: const TextStyle(fontSize: 12),
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

  void _handleBottomNavTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
    if (index == 0) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainScreen(initialIndex: index)),
        (route) => false,
      );
    }
  }
}