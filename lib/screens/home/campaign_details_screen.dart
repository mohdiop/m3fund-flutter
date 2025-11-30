import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/screens/customs/custom_campaign_card.dart';
import 'package:m3fund_flutter/screens/customs/custom_rewards_screen.dart';
import 'package:m3fund_flutter/screens/home/payment_screen.dart';
import 'package:m3fund_flutter/services/contribution_service.dart';
import 'package:m3fund_flutter/services/download_service.dart';
import 'package:m3fund_flutter/services/volunteering_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

String formatToDateAndTimeFr(DateTime date) {
  final formatter = DateFormat('d MMMM yyyy à HH:mm', 'fr_FR');
  return formatter.format(date);
}

String formatToDateFr(DateTime date) {
  final formatter = DateFormat('d MMMM yyyy', 'fr_FR');
  return formatter.format(date);
}

String getProjectDomainLabel(ProjectDomain domain) {
  switch (domain) {
    case ProjectDomain.agriculture:
      return "Agriculture";
    case ProjectDomain.breeding:
      return "Élevage";
    case ProjectDomain.education:
      return "Éducation";
    case ProjectDomain.health:
      return "Santé";
    case ProjectDomain.mine:
      return "Mine";
    case ProjectDomain.culture:
      return "Culture";
    case ProjectDomain.environment:
      return "Environnement";
    case ProjectDomain.computerScience:
      return "Informatique";
    case ProjectDomain.solidarity:
      return "Solidarité";
    case ProjectDomain.shopping:
      return "Commerce";
    case ProjectDomain.social:
      return "Social";
  }
}

String formatToFrAmount(num montant) {
  final formatter = NumberFormat("#,##0", "fr_FR");
  return formatter.format(montant).replaceAll(',', ' ');
}

class CampaignDetailsScreen extends StatefulWidget {
  final CampaignResponse campaignResponse;
  final List<Uint8List?> images;
  final Uint8List? ownerProfile;
  final bool isAuthenticated;
  const CampaignDetailsScreen({
    super.key,
    required this.campaignResponse,
    required this.images,
    required this.ownerProfile,
    required this.isAuthenticated,
  });

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  int _currentImageIndex = 0;
  late VideoPlayerController _controller;
  bool _loading = true;
  final ScrollController _scrollController = ScrollController();

  final DownloadService _downloadService = DownloadService();
  final VolunteeringService _volunteeringService = VolunteeringService();
  final ContributionService _contributionService = ContributionService();

  bool _allreadyContributed = false;
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _getAllreadyContributedState();
  }

  _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw "Impossible d'aller sur $url";
    }
  }

  _getAllreadyContributedState() async {
    if (widget.campaignResponse.type == CampaignType.volunteering) {
      var contributions = await _contributionService.getMyContributions();
      for (var volunteering in contributions.volunteering) {
        if (volunteering.campaignId == widget.campaignResponse.id) {
          setState(() {
            _allreadyContributed = true;
          });
        }
      }
    }
  }

  Future<void> _initVideo() async {
    try {
      final videoBytes = await _downloadService.fetchDataBytes(
        widget.campaignResponse.projectResponse.videoUrl,
      );
      if (videoBytes == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_video.mp4');
      await tempFile.writeAsBytes(videoBytes);

      _controller = VideoPlayerController.file(tempFile)
        ..initialize().then((_) {
          setState(() {
            _loading = false;
            _progress =
                _controller.value.position.inMilliseconds /
                (_controller.value.duration.inMilliseconds == 0
                    ? 1
                    : _controller.value.duration.inMilliseconds);
          });
          _controller.play();
        });
      _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
        if (_controller.value.isInitialized && _controller.value.isPlaying) {
          setState(() {
            _progress =
                _controller.value.position.inMilliseconds /
                (_controller.value.duration.inMilliseconds == 0
                    ? 1
                    : _controller.value.duration.inMilliseconds);
          });
        }
      });
    } catch (e) {
      debugPrint('Erreur de lecture vidéo: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: AppBar(
                  backgroundColor: Colors.white.withValues(alpha: 0.01),
                  surfaceTintColor: Colors.transparent,
                  toolbarHeight: 50,
                  leadingWidth:
                      ((MediaQuery.of(context).size.width - 350) / 2) + 40,
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipOval(
                                child: widget.ownerProfile == null
                                    ? Image.asset("assets/default.jpg")
                                    : Image.memory(
                                        widget.ownerProfile!,
                                        fit: BoxFit.cover,
                                        width: 32,
                                        height: 32,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          widget.campaignResponse.projectResponse.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  leading: Padding(
                    padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width - 350) / 2,
                    ),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: const CircleBorder(),
                        maximumSize: Size(40, 40),
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
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: (MediaQuery.of(context).size.width - 350) / 2,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Icon(
                          getDomainIcon(
                            widget.campaignResponse.projectResponse.domain,
                          ),
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(scrollbars: false, overscroll: true),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 130),

                // Carousel Slider
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: f4Grey),
                  child: widget.images.length >= 2
                      ? CarouselSlider(
                          items: widget.images
                              .map(
                                (image) => ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: image == null
                                        ? Image.asset(
                                            "assets/noImage.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.memory(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            height: 200,
                            enlargeCenterPage: true,
                            viewportFraction: 0.5,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                          ),
                        )
                      : Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: widget.images.first == null
                                ? Image.asset("assets/noImage.png")
                                : Image.memory(
                                    widget.images.first!,
                                    width: 300,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                        ),
                ),
                SizedBox(height: 20),

                // Slide Indicator
                Container(
                  decoration: BoxDecoration(
                    color: customBlackColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.images.asMap().entries.map((image) {
                      return Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == image.key
                              ? Colors.amber
                              : Color(0xFFD9D9D9),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),

                // Campaign details
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Détails sur la campagne",
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Début",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatToDateFr(
                                      widget.campaignResponse.launchedAt,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Fin",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatToDateFr(
                                      widget.campaignResponse.endAt,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              if (widget.campaignResponse.type ==
                                  CampaignType.volunteering)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Nombre de volontaires cible",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${widget.campaignResponse.targetVolunteer}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Type de campagne",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getCampaignTypeFormatted(
                                      widget.campaignResponse.type,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              if (widget.campaignResponse.type !=
                                  CampaignType.volunteering)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Budget cible",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${formatToFrAmount(widget.campaignResponse.targetBudget)} FCFA",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                              if (widget.campaignResponse.type ==
                                  CampaignType.investment)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Part au marché",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${widget.campaignResponse.shareOffered}%",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                              if (widget.campaignResponse.type ==
                                  CampaignType.donation)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Taux de financement",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${getFundingPerc(widget.campaignResponse.currentFund, widget.campaignResponse.targetBudget)} %',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                              if (widget.campaignResponse.type ==
                                  CampaignType.donation)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Fond actuel",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${formatToFrAmount(widget.campaignResponse.currentFund)} FCFA",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.campaignResponse.type ==
                                  CampaignType.volunteering)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Nombre de volontaires actuel",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${widget.campaignResponse.numberOfVolunteer}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              fixedSize: Size(320, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _allreadyContributed
                                ? null
                                : () async {
                                    if (!widget.isAuthenticated) {
                                      showRequestConnectionDialog(context);
                                    } else {
                                      switch (widget.campaignResponse.type) {
                                        case CampaignType.donation:
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PaymentScreen(
                                                  contributionWord: "Financer",
                                                  campaignResponse:
                                                      widget.campaignResponse,
                                                ),
                                              ),
                                            );
                                          }
                                        case CampaignType.volunteering:
                                          {
                                            ValueNotifier<bool> isLoading =
                                                ValueNotifier(false);
                                            showConfirmContributionDialog(
                                              context: context,
                                              campaignId:
                                                  widget.campaignResponse.id,
                                              volunteeringService:
                                                  _volunteeringService,
                                              isLoading: isLoading,
                                            );
                                          }
                                        case CampaignType.investment:
                                          {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PaymentScreen(
                                                  contributionWord: "Investir dans",
                                                  campaignResponse:
                                                      widget.campaignResponse,
                                                ),
                                              ),
                                            );
                                          }
                                      }
                                    }
                                  },
                            child: Text(
                              switch (widget.campaignResponse.type) {
                                CampaignType.donation => "Financer",
                                CampaignType.volunteering =>
                                  !_allreadyContributed
                                      ? "Contribuer"
                                      : "Vous avez déjà contribué",
                                CampaignType.investment => "Investir",
                              },
                              style: TextStyle(
                                fontSize: _allreadyContributed ? 15 : 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Video
                _loading
                    ? SizedBox(
                        width: 150,
                        height: 100,
                        child: Column(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitSpinningLines(size: 32, color: primaryColor),
                            Text(
                              "Chargement de la vidéo ...",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.black),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              (MediaQuery.of(context).size.width - 350) / 2,
                          vertical: 10,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _controller.pause(),
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                ),
                                GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final local = box.globalToLocal(
                                      details.globalPosition,
                                    );
                                    final relative = local.dx / box.size.width;
                                    final newPosition =
                                        _controller.value.duration * relative;
                                    _controller.seekTo(newPosition);
                                    _controller.play();
                                  },
                                  onTapDown: (details) {
                                    final box =
                                        context.findRenderObject() as RenderBox;
                                    final local = box.globalToLocal(
                                      details.globalPosition,
                                    );
                                    final relative = local.dx / box.size.width;
                                    final newPosition =
                                        _controller.value.duration * relative;
                                    _controller.seekTo(newPosition);
                                    _controller.play();
                                  },
                                  child: Container(
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 8),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: f4Grey,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 20,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  RemixIcons.fullscreen_line,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _controller.play(),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? null
                                      : RemixIcons.play_large_fill,
                                  size: 48,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: 20),

                // URL launcher
                InkWell(
                  onTap: () {
                    _launchURL(
                      widget.campaignResponse.projectResponse.websiteLink,
                    );
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Center(
                            child: Text(
                              widget
                                  .campaignResponse
                                  .projectResponse
                                  .websiteLink,
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          RemixIcons.external_link_line,
                          size: 24,
                          color: secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Rewards
                if (widget.campaignResponse.type == CampaignType.donation)
                  CustomRewardsScreen(rewards: widget.campaignResponse.rewards),

                SizedBox(height: 20),

                // Project details
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "Détails sur le projet",
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nom",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget
                                        .campaignResponse
                                        .projectResponse
                                        .name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Porteur",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.campaignResponse.owner.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Domaine",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    getProjectDomainLabel(
                                      widget
                                          .campaignResponse
                                          .projectResponse
                                          .domain,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Lancé le",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatToDateFr(
                                      widget
                                          .campaignResponse
                                          .projectResponse
                                          .launchedAt,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Sur la plateforme depuis le",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatToDateFr(
                                      widget
                                          .campaignResponse
                                          .projectResponse
                                          .createdAt,
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget
                                        .campaignResponse
                                        .projectResponse
                                        .description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Objectif",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget
                                        .campaignResponse
                                        .projectResponse
                                        .objective,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              InkWell(
                                onTap: () {
                                  if (!widget.isAuthenticated) {
                                    showRequestConnectionDialog(context);
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          RemixIcons.file_pdf_2_line,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "Business Model",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              fixedSize: Size(320, 54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              "Contacter ${widget.campaignResponse.owner.name}",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {
                              if (!widget.isAuthenticated) {
                                showRequestConnectionDialog(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
