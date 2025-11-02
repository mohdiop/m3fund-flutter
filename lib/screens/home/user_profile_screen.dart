import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_localization_request.dart';
import 'package:m3fund_flutter/models/requests/update/update_contributor_request.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/screens/auth/localization_screen.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:m3fund_flutter/screens/customs/custom_text_field.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/services/osm_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class UserProfileScreen extends StatefulWidget {
  final ContributorResponse user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final MapController _mapController = MapController();
  final AuthenticationService _authService = AuthenticationService();
  final UserService _userService = UserService();
  final ScrollController _scrollController = ScrollController();
  final OSMService _osmService = OSMService();
  bool _isEditModeActive = false;
  bool _isLoading = false;
  bool _isMapLoading = true;
  LatLng? _currentPosition;
  LatLng? _markerPosition;
  String _currentPositionFormatted = "";
  ContributorResponse? _user;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition(
    Function(bool) changeIsMapLoadingValue,
    Function(LatLng) changeCurrentPosition,
  ) async {
    if (mounted) {
      changeIsMapLoadingValue(true);
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Activez la localisation');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomTopSnackBar(context, "La permission a été refusée");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showCustomTopSnackBar(context, "Permission refusée définitivement");
    }

    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    if (!mounted) return;
    changeCurrentPosition(latLng);
    changeIsMapLoadingValue(false);
    _loadPositionFromOSM(latLng, (position) {
      setState(() {
        _currentPositionFormatted =
            "${position.street == "" ? position.town : position.street}, ${position.region}, ${position.country}";
      });
    });
  }

  Widget _customProfileSubSection({
    required IconData icon,
    required String title,
    required String value,
    required bool isEditable,
    Future<void> Function()? onClick,
  }) {
    return GestureDetector(
      onTap: onClick != null
          ? () async {
              await onClick();
            }
          : null,
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: f4Grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          spacing: 10,

          children: [
            Icon(icon, color: primaryColor),
            SizedBox(
              width: (MediaQuery.of(context).size.width) <= 375
                  ? MediaQuery.of(context).size.width <= 350
                        ? 136
                        : 166
                  : MediaQuery.of(context).size.width / 2.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isEditable && _isEditModeActive)
              Icon(RemixIcons.arrow_right_s_line),
          ],
        ),
      ),
    );
  }

  void _showEdtiNamesDialog({required Future<void> Function() action}) {
    _firstNameController.text = _user!.firstName;
    _lastNameController.text = _user!.lastName;
    showGeneralDialog(
      context: context,
      barrierLabel: "Modification des noms",
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withValues(alpha: 0)),
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
                            "Modifiez vos noms",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Icon(
                            RemixIcons.user_3_fill,
                            size: 44,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            icon: null,
                            hintText: "Prénom",
                            isPassword: false,
                            controller: _firstNameController,
                            width: 200,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            icon: null,
                            hintText: "Nom",
                            isPassword: false,
                            controller: _lastNameController,
                            width: 200,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _isLoading = false;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    backgroundColor: f4Grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Quitter",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          setStateDialog(() {
                                            _isLoading = true;
                                          });
                                          await action();
                                          setStateDialog(() {
                                            _isLoading = false;
                                            _isEditModeActive = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: SpinKitSpinningLines(
                                            color: primaryColor,
                                            size: 28,
                                          ),
                                        )
                                      : Text(
                                          "Modifier",
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

  Future<void> _showChangeLocalizationDialog({
    required Future<void> Function() action,
  }) async {
    setState(() {
      _isMapLoading = false;
    });
    showGeneralDialog(
      context: context,
      barrierLabel: "Modification de la localization",
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, __, ___) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withValues(alpha: 0)),
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
                            "Modifiez votre localization",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 44,
                            padding: EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                  color: Colors.black.withValues(alpha: 0.2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _currentPositionFormatted,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _determinePosition(
                                      (value) {
                                        setStateDialog(() {
                                          _isMapLoading = value;
                                        });
                                      },
                                      (value) {
                                        setStateDialog(() {
                                          _currentPosition = value;
                                          _markerPosition = value;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        RemixIcons.map_pin_user_line,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: mounted
                                  ? _isMapLoading
                                        ? Center(
                                            child: SpinKitSpinningLines(
                                              color: primaryColor,
                                              size: 32,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10,
                                                ),
                                            child: FlutterMap(
                                              mapController: _mapController,
                                              options: MapOptions(
                                                initialCenter:
                                                    _currentPosition!,
                                                initialZoom: 15,
                                                onTap: (tapPosition, latLng) {
                                                  setStateDialog(() {
                                                    _isMapLoading = true;
                                                    _markerPosition = latLng;
                                                    _currentPosition = latLng;
                                                    _isMapLoading = false;
                                                  });
                                                  _loadPositionFromOSM(latLng, (
                                                    position,
                                                  ) {
                                                    setStateDialog(() {
                                                      _currentPositionFormatted =
                                                          "${position.street == "" ? position.town : position.street}, ${position.region}, ${position.country}";
                                                    });
                                                  });
                                                },
                                                onMapReady: () async {
                                                  if (_currentPosition !=
                                                      null) {
                                                    _mapController.move(
                                                      _currentPosition!,
                                                      15,
                                                    );
                                                  }
                                                },
                                              ),
                                              children: [
                                                openStreetMapTileLayer,
                                                MarkerLayer(
                                                  markers: [
                                                    Marker(
                                                      point: _markerPosition!,
                                                      width: 60,
                                                      height: 60,
                                                      child: const Icon(
                                                        Icons.location_on,
                                                        color: primaryColor,
                                                        size: 45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                  : SpinKitSpinningLines(
                                      color: primaryColor,
                                      size: 32,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _isLoading = false;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    backgroundColor: f4Grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Quitter",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          setStateDialog(() {
                                            _isLoading = true;
                                          });
                                          await action();
                                          setStateDialog(() {
                                            _isLoading = false;
                                            _isEditModeActive = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: primaryColor,
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: SpinKitSpinningLines(
                                            color: primaryColor,
                                            size: 28,
                                          ),
                                        )
                                      : Text(
                                          "Modifier",
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

  @override
  void initState() {
    setState(() {
      _user = widget.user;
      _currentPosition = LatLng(
        _user!.localization.latitude,
        _user!.localization.longitude,
      );
      _markerPosition = LatLng(
        _user!.localization.latitude,
        _user!.localization.longitude,
      );
    });
    _loadPositionFromOSM(_currentPosition!, (position) {
      setState(() {
        _currentPositionFormatted =
            "${position.street == "" ? position.town : position.street}, ${position.region}, ${position.country}";
      });
    });
    super.initState();
  }

  Future<void> _loadPositionFromOSM(
    LatLng pos,
    Function(CreateLocalizationRequest) func,
  ) async {
    var osmPosition = await _osmService.getAddressFromOSM(
      pos.latitude,
      pos.longitude,
    );
    var position = CreateLocalizationRequest(
      country: osmPosition['country'].toString(),
      region: osmPosition['region'].toString(),
      town: osmPosition['city'].toString(),
      street: osmPosition['district'].toString(),
      longitude: _currentPosition!.longitude,
      latitude: _currentPosition!.latitude,
    );
    func(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                toolbarHeight: 50,
                leadingWidth: 50,
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
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Center(
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: f4Grey,
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(
                          RemixIcons.logout_circle_r_line,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () async {
                          showLogoutDialog(context, () async {
                            await _authService.logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        scrollBehavior: ScrollConfiguration.of(
          context,
        ).copyWith(scrollbars: false),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            leading: null,
            expandedHeight: MediaQuery.of(context).size.width,
            collapsedHeight: 60,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(shape: BoxShape.rectangle),
                    child: Image.asset("assets/woman.png", fit: BoxFit.cover),
                  ),
                  Positioned.fromRect(
                    rect: Rect.fromLTRB(
                      MediaQuery.of(context).size.width - (30 + 44),
                      MediaQuery.of(context).size.width - (30 + 44),
                      MediaQuery.of(context).size.width - 30,
                      MediaQuery.of(context).size.width - 30,
                    ),
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Center(
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          icon: Icon(
                            RemixIcons.image_edit_line,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Informations personnelles",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            _customProfileSubSection(
                              icon: RemixIcons.user_3_fill,
                              title: "Nom Complet",
                              value: "${_user?.firstName} ${_user?.lastName}",
                              isEditable: true,
                              onClick: _isEditModeActive
                                  ? () async {
                                      _showEdtiNamesDialog(
                                        action: () async {
                                          UpdateContributorRequest
                                          updateContributorRequest =
                                              UpdateContributorRequest();
                                          if (_firstNameController
                                              .text
                                              .isNotEmpty) {
                                            updateContributorRequest.firstName =
                                                _firstNameController.text;
                                          }
                                          if (_lastNameController
                                              .text
                                              .isNotEmpty) {
                                            updateContributorRequest.lastName =
                                                _lastNameController.text;
                                          }
                                          try {
                                            var resp = await _userService
                                                .patchUser(
                                                  contributor:
                                                      updateContributorRequest,
                                                );
                                            setState(() {
                                              _user = resp;
                                            });
                                            showCustomTopSnackBar(
                                              context,
                                              "Modification effectuée avec succès.",
                                            );
                                          } catch (e) {
                                            showCustomTopSnackBar(
                                              context,
                                              e.toString(),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  : null,
                            ),
                            _customProfileSubSection(
                              icon: RemixIcons.phone_fill,
                              title: "Numéro de téléphone",
                              value: _user!.phone,
                              isEditable: false,
                            ),
                            _customProfileSubSection(
                              icon: RemixIcons.mail_fill,
                              title: "Email",
                              value: _user!.email,
                              isEditable: false,
                            ),
                            _customProfileSubSection(
                              icon: RemixIcons.map_pin_fill,
                              title: "Position",
                              value:
                                  "${_user!.localization.street == "" ? _user!.localization.town : _user!.localization.street}, ${_user!.localization.region}, ${_user!.localization.country}",
                              isEditable: true,
                              onClick: _isEditModeActive
                                  ? () async {
                                      await _showChangeLocalizationDialog(
                                        action: () async {
                                          if (_currentPosition != null) {
                                            CreateLocalizationRequest?
                                            localization;
                                            await _loadPositionFromOSM(
                                              _currentPosition!,
                                              (value) {
                                                localization = value;
                                              },
                                            );
                                            try {
                                              var user = await _userService
                                                  .patchUser(
                                                    contributor:
                                                        UpdateContributorRequest(
                                                          localization:
                                                              localization,
                                                        ),
                                                  );
                                              setState(() {
                                                _user = user;
                                              });
                                            } catch (e) {
                                              showCustomTopSnackBar(
                                                context,
                                                e.toString(),
                                              );
                                            }
                                          }
                                        },
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "Pour modifier le numéro de téléphone ou l’email allez-y dans ",
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: "Paramètres → Compte.",
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isEditModeActive
                                  ? f4Grey
                                  : primaryColor,
                              foregroundColor: _isEditModeActive
                                  ? Colors.black
                                  : Colors.white,
                              fixedSize: Size(150, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditModeActive = !_isEditModeActive;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  _isEditModeActive ? "Quitter" : "Modifier",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _isEditModeActive
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                if (!_isEditModeActive)
                                  Icon(
                                    RemixIcons.pencil_line,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Membre depuis le ${formatToDateFr(_user!.createdAt)}.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 2.7),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
