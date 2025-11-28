import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/create/create_contributor_request.dart';
import 'package:m3fund_flutter/models/requests/create/create_localization_request.dart';
import 'package:m3fund_flutter/screens/auth/success_signin_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/services/osm_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LocalizationScreen extends StatefulWidget {
  final CreateContributorRequest contributorRequest;
  const LocalizationScreen({super.key, required this.contributorRequest});

  @override
  State<LocalizationScreen> createState() => _LocalizationScreenState();
}

class _LocalizationScreenState extends State<LocalizationScreen> {
  final MapController _mapController = MapController();
  final OSMService _osmService = OSMService();
  final AuthenticationService _authenticationService = AuthenticationService();
  LatLng? _currentPosition;
  LatLng? _markerPosition;
  bool _isLoading = true;
  final ValueNotifier<bool> _loadForRegistration = ValueNotifier(false);
  bool _positionLoading = false;

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  Future<void> _determinePosition() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Activez la localisation');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission refusée');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permission refusée définitivement');
    }

    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    if (!mounted) return;
    setState(() {
      _currentPosition = latLng;
      _markerPosition = latLng;
      _isLoading = false;
    });
  }

  void _moveMarker(LatLng position) {
    setState(() {
      _markerPosition = position;
      _currentPosition = position;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loadForRegistration.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: (MediaQuery.of(context).size.width - 350) / 2,
              ),
              child: IconButton(
                style: IconButton.styleFrom(backgroundColor: primaryColor),
                icon: const Icon(
                  RemixIcons.user_location_line,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (!_isLoading) await _determinePosition();
                },
              ),
            ),
          ],
          backgroundColor: Colors.white.withValues(alpha: 0.01),
          surfaceTintColor: Colors.transparent,
          leadingWidth: 43 + ((MediaQuery.of(context).size.width - 350) / 2),
          leading: Padding(
            padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width - 350) / 2,
            ),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
                fixedSize: Size(24, 24),
              ),
              icon: Icon(
                RemixIcons.arrow_left_line,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: mounted
                ? _isLoading
                      ? Center(
                          child: SpinKitSpinningLines(
                            color: primaryColor,
                            size: 62,
                            lineWidth: 3,
                          ),
                        )
                      : FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _currentPosition!,
                            initialZoom: 15,
                            onTap: (tapPosition, latLng) => _moveMarker(latLng),
                            onMapReady: () async {
                              if (_currentPosition != null) {
                                _mapController.move(_currentPosition!, 15);
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
                        )
                : SpinKitSpinningLines(color: primaryColor, size: 32),
          ),
        ),
        bottomSheet: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _positionLoading ? f4Grey : primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: Size(300, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _positionLoading
                        ? SpinKitSpinningLines(color: primaryColor, size: 32)
                        : Text("Continuer", style: TextStyle(fontSize: 24)),
                    onPressed: () async {
                      if (_currentPosition != null) {
                        try {
                          setState(() {
                            _positionLoading = true;
                          });
                          final onValue = await _osmService.getAddressFromOSM(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          );
                          setState(() {
                            _positionLoading = false;
                          });
                          if (context.mounted) {
                            showBlurLocalizationDialog(
                              isLoading: _loadForRegistration,
                              context: context,
                              title: "Votre position actuelle",
                              content:
                                  "Votre position actuelle est à ${onValue['district']}, ${onValue['city']}, ${onValue['region']}, ${onValue['country']}. Cela nous permettra de vous proposer des contenus plus personnalisés dans l'environ.",
                              actionText: "S'inscrire",
                              closureText: "Annuler",
                              icon: RemixIcons.user_location_line,
                              action: () async {
                                widget.contributorRequest.localization =
                                    CreateLocalizationRequest(
                                      country: onValue['country'].toString(),
                                      region: onValue['region'].toString(),
                                      town: onValue['city'].toString(),
                                      street: onValue['district'].toString(),
                                      longitude: _currentPosition!.longitude,
                                      latitude: _currentPosition!.latitude,
                                    );

                                try {
                                  await _authenticationService.register(
                                    createContributorRequest:
                                        widget.contributorRequest,
                                  );
                                  await _authenticationService.login(
                                    authenticationRequest:
                                        AuthenticationRequest(
                                          username:
                                              widget.contributorRequest.email,
                                          password: widget
                                              .contributorRequest
                                              .password,
                                        ),
                                  );
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => SuccessSigninScreen(),
                                      ),
                                      (_) => false,
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.brown,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.brown,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate:
      'https://api.maptiler.com/maps/openstreetmap/{z}/{x}/{y}.jpg?key=6Xnb0HvnIxAw4DOLZPdW',
  userAgentPackageName: 'com.mohdiop.m3fund',
);
