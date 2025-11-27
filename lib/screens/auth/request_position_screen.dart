import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:remixicon/remixicon.dart';

class RequestPositionScreen extends StatefulWidget {
  const RequestPositionScreen({super.key});

  @override
  State<RequestPositionScreen> createState() => _RequestPositionScreenState();
}

class _RequestPositionScreenState extends State<RequestPositionScreen> {
  final ScrollController _scrollController = ScrollController();

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
                    "Voulez-vous nous fournir votre photo position",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 50),
                  Image.asset("assets/position.png", width: 200, height: 200),
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
              onPressed: () {},
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
