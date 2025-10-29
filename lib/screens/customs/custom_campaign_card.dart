import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/services/download_service.dart';
import 'package:remixicon/remixicon.dart';

IconData getDomainIcon(ProjectDomain domain) {
  switch (domain) {
    case ProjectDomain.agriculture:
      return RemixIcons.flower_line;
    case ProjectDomain.mine:
      return RemixIcons.building_2_line;
    case ProjectDomain.health:
      return RemixIcons.heart_2_line;
    case ProjectDomain.education:
      return RemixIcons.graduation_cap_line;
    case ProjectDomain.computerScience:
      return RemixIcons.mac_line;
    case ProjectDomain.environment:
      return RemixIcons.leaf_line;
    case ProjectDomain.solidarity:
      return RemixIcons.service_line;
    case ProjectDomain.breeding:
      return MdiIcons.sheep;
    case ProjectDomain.social:
      return MdiIcons.accountGroup;
    case ProjectDomain.shopping:
      return RemixIcons.shopping_cart_line;
    default:
      return RemixIcons.information_line;
  }
}

String getCampaignTypeFormatted(CampaignType campaignType) {
  switch (campaignType) {
    case CampaignType.donation:
      return "Don";
    case CampaignType.volunteering:
      return "Bénévolat";
    case CampaignType.investment:
      return "Investissement";
  }
}

String getFundingPerc(double currentFund, double targetFund) {
  return ((100 * currentFund) / targetFund).toStringAsFixed(2);
}

class CustomCampaignCard extends StatefulWidget {
  final CampaignResponse campaign;
  final bool isAuthenticated;
  const CustomCampaignCard({
    super.key,
    required this.campaign,
    required this.isAuthenticated,
  });

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
      final imageBytes = await _downloadService.fetchDataBytes(imageUrl);
      prepImgs.add(imageBytes);
    }
    Uint8List? ownerProfileBytes;
    if (widget.campaign.owner.profileUrl != "") {
      ownerProfileBytes = await _downloadService.fetchDataBytes(
        widget.campaign.owner.profileUrl,
      );
    }
    if (!mounted) return;
    setState(() {
      _images.addAll(prepImgs);
      _isLoading = false;
      _ownerProfile = ownerProfileBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CampaignDetailsScreen(
                campaignResponse: widget.campaign,
                images: _images,
                ownerProfile: _ownerProfile,
                isAuthenticated: widget.isAuthenticated,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _isLoading ? Colors.white : customBlackColor,
          ),
          child: SizedBox(
            height: 250,
            width: 300,
            child: Stack(
              children: [
                _isLoading
                    ? SpinKitSpinningLines(size: 44, color: primaryColor)
                    : Stack(
                        children: [
                          // Background
                          Positioned.fill(
                            child: _images.length > 1
                                ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: CarouselSlider(
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
                                      items: _images
                                          .map(
                                            (image) => ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: image == null
                                                    ? Image.asset(
                                                        "assets/noImage.png",
                                                      )
                                                    : Image.memory(
                                                        image,
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                : Image.memory(_images.first!),
                          ),

                          // Profile and Name
                          Positioned.fromRect(
                            rect: Rect.fromLTRB(10, 10, 220, 42),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          width: 32,
                                          height: 32,
                                          child: _ownerProfile == null
                                              ? Image.asset(
                                                  "assets/default.jpg",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.memory(
                                                  _ownerProfile!,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: SizedBox(
                                          width: 158,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            widget.campaign.owner.name,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
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
                          ),

                          // Project domain
                          Positioned.fromRect(
                            rect: Rect.fromLTRB(258, 10, 290, 42),
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    getDomainIcon(
                                      widget.campaign.projectResponse.domain,
                                    ),
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Bottom background
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
                                                        BorderRadius.circular(
                                                          32,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      getCampaignTypeFormatted(
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
                                          widget
                                              .campaign
                                              .projectResponse
                                              .resume,
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
                                                    "${getFundingPerc(widget.campaign.currentFund, widget.campaign.targetBudget)} %",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        .numberOfVolunteer
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    " volontaire${widget.campaign.numberOfVolunteer > 1 ? "s" : ""} sur ",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget
                                                        .campaign
                                                        .targetVolunteer
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
      ),
    );
  }
}
