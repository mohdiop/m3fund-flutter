import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/main.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/screens/home/campaigns_screen.dart';
import 'package:m3fund_flutter/screens/home/user_profile_screen.dart';
import 'package:m3fund_flutter/services/notification_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';
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
    ContributorResponse loadedUser = await _userService.me();
    setState(() {
      _user = loadedUser;
    });
    var notifications = await _notificationService.getMyNotifications();
    for (var notification in notifications) {
      if (!notification.isRead) {
        setState(() {
          _hasUnreadNotifications = true;
        });
      }
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
        centerTitle: true,
        title: widget.isAuthenticated
            ? Text(
                "${_greetingWordByTime()}, ${_user?.lastName ?? ''}",
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              )
            : null,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 14, top: 10, bottom: 10),
          child: Image.asset("assets/nbLogoName.png"),
        ),
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
                            fontSize: 12,
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
        actions: [
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
              margin: EdgeInsets.only(right: 14),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: customBlackColor, width: 3),
              ),
              child: ClipOval(
                child: Image.asset("assets/default.jpg", fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: CampaignsScreen(
        isAuthenticated: widget.isAuthenticated,
        userPosition:
            "${_user?.localization.street ?? _user?.localization.town ?? 'Quartier'}, ${_user?.localization.region ?? 'Ville'}, ${_user?.localization.country ?? 'Pays'}",
      ),
    );
  }
}
