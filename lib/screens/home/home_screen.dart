import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/main.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/screens/home/campaigns_screen.dart';
import 'package:m3fund_flutter/screens/home/notifications_screen.dart';
import 'package:m3fund_flutter/screens/home/user_profile_screen.dart';
import 'package:m3fund_flutter/services/download_service.dart';
import 'package:m3fund_flutter/services/notification_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';
import 'package:m3fund_flutter/tools/notification_read_storage.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class HomeScreen extends StatefulWidget {
  final bool isAuthenticated;
  const HomeScreen({super.key, required this.isAuthenticated});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _hasUnreadNotifications = false;
  ContributorResponse? _user;

  final UserService _userService = UserService();
  final NotificationService _notificationService = NotificationService();
  final NotificationReadStorage _notificationReadStorage =
      NotificationReadStorage.instance;

  bool _loadingForProfile = true;

  final DownloadService _downloadService = DownloadService();

  Uint8List? _userProfile;

  _initUserProfilePicture() async {
    if (_user!.profilePictureUrl != null) {
      try {
        final profile = await _downloadService.fetchDataBytes(
          _user!.profilePictureUrl!,
        );
        setState(() {
          if (profile != null) {
            _userProfile = profile;
          }
        });
      } catch (e) {
        showCustomTopSnackBar(context, "Erreur lors du chargement du profil");
      } finally {
        setState(() {
          _loadingForProfile = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    if (widget.isAuthenticated) {
      _loadUserInfo();
    }
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final loadedUser = await _userService.me();
      final notifications = await _notificationService.getMyNotifications();
      final readIds = await _notificationReadStorage.loadReadIds();

      bool hasUnread = false;
      for (var notification in notifications) {
        final alreadyRead =
            notification.isRead || readIds.contains(notification.id);
        if (!alreadyRead) {
          hasUnread = true;
          break;
        }
      }

      if (!mounted) return;
      setState(() {
        _user = loadedUser;
        _hasUnreadNotifications = hasUnread;
      });
      await _initUserProfilePicture();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasUnreadNotifications = false;
      });
    }
  }

  String _greetingWordByTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 14) {
      return "Bonjour";
    } else {
      return "Bonsoir";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 110,
        toolbarHeight: 70,
        centerTitle: widget.isAuthenticated,
        title: widget.isAuthenticated
            ? Text(
                "${_greetingWordByTime()}, ${_user?.lastName ?? ''}",
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              )
            : Padding(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - 350) / 2,
                  top: 10,
                  bottom: 10,
                ),
                child: Image.asset("assets/nbLogoName.png", height: 32),
              ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: widget.isAuthenticated
            ? Padding(
                padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width - 350) / 2,
                  top: 10,
                  bottom: 10,
                ),
                child: Image.asset("assets/nbLogoName.png", height: 24),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: Size(350, 44),
          child: ClipRRect(
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(color: Colors.white),
              alignment: AlignmentGeometry.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    width: 295,
                    height: 44,
                    child: TextField(
                      cursorColor: customBlackColor,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: f4Grey,
                        hoverColor: f4Grey,
                        hint: Text(
                          "Rechercher par ici ...",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ),
                        prefixIcon: Icon(RemixIcons.search_2_line, size: 24),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: customBlackColor.withValues(alpha: 0.6),
                        ),
                        child: Icon(
                          RemixIcons.equalizer_2_line,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: !widget.isAuthenticated
            ? null
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: primaryColor,
                      maximumSize: Size(40, 40),
                    ),
                    icon: Stack(
                      children: [
                        Icon(
                          RemixIcons.notification_line,
                          size: 24,
                          color: Colors.white,
                        ),
                        if (_hasUnreadNotifications)
                          Positioned(
                            width: 10,
                            height: 10,
                            top: 0,
                            left: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      if (!widget.isAuthenticated) {
                        showRequestConnectionDialog(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (!widget.isAuthenticated) {
                      showRequestConnectionDialog(context);
                    } else {
                      if (_user == null) {
                        await showCustomTopSnackBar(
                          context,
                          "Impossible de charger les données pour l'instant ...",
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserProfileScreen(user: _user!),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: (MediaQuery.of(context).size.width - 350) / 2,
                    ),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: customBlackColor, width: 3),
                    ),
                    child: ClipOval(
                      child: _userProfile == null
                          ? _loadingForProfile
                                ? SpinKitSpinningLines(
                                    color: primaryColor,
                                    size: 32,
                                    lineWidth: 3,
                                  )
                                : Image.asset("assets/default.jpg")
                          : Image.memory(_userProfile!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
      ),
      extendBodyBehindAppBar: true,
      body: CampaignsScreen(
        isAuthenticated: widget.isAuthenticated,
        userPosition: _user?.localization == null
            ? null
            : "${_user?.localization!.street ?? _user?.localization!.town ?? 'Quartier'}, ${_user?.localization!.region ?? 'Ville'}, ${_user?.localization!.country ?? 'Pays'}",
      ),
    );
  }
}
