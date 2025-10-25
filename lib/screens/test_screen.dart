import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:m3fund_flutter/services/campaign_service.dart';
import 'package:m3fund_flutter/services/download_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  AuthenticationService authenticationService = AuthenticationService();
  UserService userService = UserService();
  CampaignService campaignService = CampaignService();

  final DownloadService _downloadService = DownloadService();

  Uint8List? bytes;

  @override
  void initState() {
    initImg();
    super.initState();
  }

  Future<void> initImg() async {
    setState(() async {
      bytes = await _downloadService.fetchImageBytes(
        "C:\\Users\\moham\\Desktop\\m3fund\\pictures\\f42fd4c2-8aa1-4651-9a03-31c946a32705.png",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("M3Fund")),
      body: Center(
        child: Builder(
          builder: (context) => Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    var user = await userService.me();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(user.id.toString()),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text("Get my infos"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authenticationService.login(
                      authenticationRequest: AuthenticationRequest(
                        email: "mohameddiop1951@gmail.com",
                        password: "Test@1234",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Utilisateur connecté"),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text("Connect user"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authenticationService.logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Utilisateur déconnecté"),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text("Disconnect user"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    var allCampaigns = await campaignService.getAllCampaigns();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(allCampaigns.first.rewards.first.name),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.brown,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Text("Get all campaigns"),
              ),
              bytes == null
                  ? Text("Failed")
                  : SizedBox(
                      width: 100,
                      child: Image.memory(bytes!, fit: BoxFit.cover),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
