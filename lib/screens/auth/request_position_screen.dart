import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/authentication_request.dart';
import 'package:m3fund_flutter/models/requests/create/create_contributor_request.dart';
import 'package:m3fund_flutter/screens/auth/localization_screen.dart';
import 'package:m3fund_flutter/screens/auth/success_signin_screen.dart';
import 'package:m3fund_flutter/services/authentication_service.dart';
import 'package:remixicon/remixicon.dart';

class RequestPositionScreen extends StatefulWidget {
  final CreateContributorRequest contributor;
  const RequestPositionScreen({super.key, required this.contributor});

  @override
  State<RequestPositionScreen> createState() => _RequestPositionScreenState();
}

class _RequestPositionScreenState extends State<RequestPositionScreen> {
  final ScrollController _scrollController = ScrollController();
  var _isLoading = false;
  final _authenticationService = AuthenticationService();

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
                    "Voudriez-vous nous fournir votre position ?",
                    style: TextStyle(fontSize: 24),
                  ),
                  Center(
                    child: Column(
                      spacing: 10,
                      children: [
                        Image.asset("assets/position.png", width: 230),
                        Text(
                          "Nous utilisons votre position afin de vous recommander des contenus dans votre zone.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Cela vise principalement à assurer la compatibilité des méthodes de paiements utilisés",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
              onPressed: _isLoading
                  ? null
                  : () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        await _authenticationService.register(
                          createContributorRequest: widget.contributor,
                        );
                        await _authenticationService.login(
                          authenticationRequest: AuthenticationRequest(
                            username: widget.contributor.email,
                            password: widget.contributor.password,
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
                            content: Text(
                              e.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
              child: _isLoading
                  ? SpinKitSpinningLines(color: primaryColor, size: 24)
                  : Text("Non", style: TextStyle(fontSize: 20)),
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
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LocalizationScreen(
                            contributorRequest: widget.contributor,
                          ),
                        ),
                      );
                    },
              child: Text("Oui", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
