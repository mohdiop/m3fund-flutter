import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_contributor_request.dart';
import 'package:m3fund_flutter/screens/auth/user_prefs_screen.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';
import 'package:twemoji/twemoji.dart';

class ProfilePictureScreen extends StatefulWidget {
  final CreateContributorRequest contributorRequest;
  const ProfilePictureScreen({super.key, required this.contributorRequest});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  final _scrollController = ScrollController();
  XFile? _profilePicture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white.withValues(alpha: 0.01),
        surfaceTintColor: Colors.transparent,
        leadingWidth: ((MediaQuery.of(context).size.width - 350) / 2) + 43,
        leading: Padding(
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - 350) / 2,
          ),
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
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: SizedBox(
              width: 339,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Définissez votre photo de profil",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () async {
                      final img = await pickImageFromGallery();
                      setState(() {
                        _profilePicture = img;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: secondaryColor.withValues(alpha: 0.4),
                          width: 5,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: f4Grey, width: 5),
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: _profilePicture != null
                                ? Image.file(
                                    File(_profilePicture!.path),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/noImage.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Twemoji(
                    emoji: '👆',
                    height: 48,
                    width: 48,
                    twemojiFormat: TwemojiFormat.png,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _profilePicture == null
                        ? "Cliquer pour téléverser une photo"
                        : "Cliquer pour modifier la photo",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: f4Grey,
                foregroundColor: Colors.black,
                fixedSize: Size(160, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Passer", style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserPrefsScreen(
                      contributorRequest: widget.contributorRequest,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                fixedSize: Size(160, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Continuer", style: TextStyle(fontSize: 20)),
              onPressed: () {
                if (_profilePicture == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Pour continuer, veuillez définir votre photo de profil.",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: primaryColor,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  widget.contributorRequest.profilePicture = _profilePicture;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserPrefsScreen(
                        contributorRequest: widget.contributorRequest,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
