import 'package:flutter/material.dart';
import 'package:m3fund_flutter/models/enums/enums.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/create_contributor_request.dart';
import 'package:m3fund_flutter/models/requests/create_localization_request.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';

Future<void> main() async {
  AuthenticationService authenticationService = AuthenticationService();

  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("M3Fund")),
        body: Center(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                try {
                  var user = await authenticationService.register(
                    createContributorRequest: CreateContributorRequest(
                      firstName: 'Mohamed',
                      lastName: 'Diop',
                      localization: CreateLocalizationRequest(
                        region: 'Koulikoro',
                        town: 'Bamako',
                        street: 'Faladiè',
                        longitude: 23.00,
                        latitude: 22.00,
                      ),
                      projectDomainPrefs: [ProjectDomain.agriculture],
                      campaignTypePrefs: [CampaignType.donation],
                      email: 'mohameddiop1951@gmail.com',
                      phone: '+22380000000',
                      password: 'Test@1234',
                    ),
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(user.id.toString()),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text("Test"),
            ),
          ),
        ),
      ),
    ),
  );
}
