import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/services/download_service.dart';

class CustomCampaignCard extends StatefulWidget {
  final CampaignResponse campaign;
  const CustomCampaignCard({super.key, required this.campaign});

  @override
  State<CustomCampaignCard> createState() => _CustomCampaignCardState();
}

class _CustomCampaignCardState extends State<CustomCampaignCard> {
  final DownloadService _downloadService = DownloadService();

  final List<Uint8List?> _images = [];
  bool _isLoading = true;
  Uint8List? _ownerProfile;

  @override
  void initState() {
    _initBackgroundImage();
    super.initState();
  }

  String _getCampaignTypeFormatted(CampaignType campaignType) {
    switch (campaignType) {
      case CampaignType.donation:
        return "Don";
      case CampaignType.volunteering:
        return "Bénévolat";
      case CampaignType.investment:
        return "Investissement";
    }
  }

  double _getFundingPerc(double currentFund, double targetFund) {
    return (100 * currentFund) / targetFund;
  }

  String _timeRemaining(DateTime endAt) {
    final now = DateTime.now();
    if (endAt.isBefore(now)) {
      return "Terminée";
    }

    final difference = endAt.difference(now);

    final years = (difference.inDays / 365).floor();
    final months = (difference.inDays / 30).floor();
    final weeks = (difference.inDays / 7).floor();
    final days = difference.inDays;
    final hours = difference.inHours;
    final minutes = difference.inMinutes;

    if (years >= 1) {
      return "$years ${years > 1 ? 'ans' : 'an'}";
    } else if (months >= 1) {
      return "$months ${months > 1 ? 'mois' : 'mois'}";
    } else if (weeks >= 1) {
      return "$weeks ${weeks > 1 ? 'semaines' : 'semaine'}";
    } else if (days >= 1) {
      return "$days ${days > 1 ? 'jours' : 'jour'}";
    } else if (hours >= 1) {
      return "$hours ${hours > 1 ? 'heures' : 'heure'}";
    } else if (minutes >= 1) {
      return "$minutes ${minutes > 1 ? 'minutes' : 'minute'}";
    } else {
      return "quelques secondes";
    }
  }

  Future<void> _initBackgroundImage() async {
    List<Uint8List?> prepImgs = [];
    for (var imageUrl in widget.campaign.projectResponse.imagesUrl) {
      final imageBytes = await _downloadService.fetchImageBytes(imageUrl);
      prepImgs.add(imageBytes);
    }
    final ownerProfileBytes = await _downloadService.fetchImageBytes(
      widget.campaign.owner.profileUrl,
    );
    if (!mounted) return;
    setState(() {
      _images.addAll(prepImgs);
      _isLoading = false;
      _ownerProfile = ownerProfileBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: customBlackColor,
        ),
        child: SizedBox(
          height: 250,
          width: 300,
          child: Stack(
            children: [
              _isLoading
                  ? SpinKitSpinningLines(size: 32, color: primaryColor)
                  : Stack(
                      children: [
                        // Background
                        Positioned.fill(
                          child: _images.length > 1
                              ? CarouselSlider(
                                  disableGesture: true,
                                  options: CarouselOptions(
                                    height: 250,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    scrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    viewportFraction: 0.9,
                                    autoPlayInterval: const Duration(
                                      seconds: 3,
                                    ),
                                  ),
                                  items: [
                                    for (var image in _images)
                                      if (image != null)
                                        SizedBox(
                                          width: 350,
                                          height: 250,
                                          child: Image.memory(
                                            image,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                  ],
                                )
                              : Image.memory(_images.first!),
                        ),

                        Positioned.fromRect(
                          rect: Rect.fromLTRB(10, 10, 220, 54),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 20.0,
                                sigmaY: 20.0,
                              ),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: _ownerProfile == null
                                          ? Image.asset("assets/default.jpg")
                                          : Image.memory(_ownerProfile!),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Foreground
                        Positioned.fromRect(
                          rect: Rect.fromLTRB(0, 150, 300, 250),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 20.0,
                                sigmaY: 20.0,
                              ),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.2),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 280,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget
                                                  .campaign
                                                  .projectResponse
                                                  .name,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              width: 120,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _getCampaignTypeFormatted(
                                                      widget.campaign.type,
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 280,
                                      height: 35,
                                      child: Text(
                                        widget.campaign.projectResponse.resume,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 280,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Il reste ",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            _timeRemaining(
                                              widget.campaign.endAt,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            " ~ ",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          switch (widget.campaign.type) {
                                            CampaignType.donation => Row(
                                              children: [
                                                Text(
                                                  "Financé à ",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "${_getFundingPerc(widget.campaign.currentFund, widget.campaign.targetBudget)} %",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CampaignType.volunteering => Row(
                                              children: [
                                                Text(
                                                  widget
                                                      .campaign
                                                      .targetVolunteer
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  " volontaires",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            CampaignType.investment => Row(
                                              children: [
                                                Text(
                                                  "${widget.campaign.shareOffered.toString()} %",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  " de part à vendre",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          },
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }
}
