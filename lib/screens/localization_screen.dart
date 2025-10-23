import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/create_contributor_request.dart';
import 'package:m3fund_flutter/models/requests/create_localization_request.dart';
import 'package:m3fund_flutter/screens/home_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/services/osm_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

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

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() => _isLoading = true);

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

    _mapController.move(latLng, 15);
  }

  // Déplacer le marqueur à l’endroit cliqué
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentPosition == null || _markerPosition == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: primaryColor,
          ),
        ),
      );
    }
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
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                style: IconButton.styleFrom(backgroundColor: primaryColor),
                icon: const Icon(
                  RemixIcons.user_location_line,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: _determinePosition,
              ),
            ),
          ],
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
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
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 15,
                onTap: (tapPosition, latLng) => _moveMarker(latLng),
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
          ),
        ),
        bottomSheet: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: Size(300, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Continuer", style: TextStyle(fontSize: 24)),
                    onPressed: () async {
                      if (_currentPosition != null) {
                        try {
                          final onValue = await _osmService.getAddressFromOSM(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          );

                          showBlurDialog(
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
                                  authenticationRequest: AuthenticationRequest(
                                    email: widget.contributorRequest.email,
                                    password:
                                        widget.contributorRequest.password,
                                  ),
                                );
                                if (context.mounted) {
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                      (Route<dynamic> route) =>
                                          false,
                                    );
                                  }
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
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.mohdiop.m3fund',
);
