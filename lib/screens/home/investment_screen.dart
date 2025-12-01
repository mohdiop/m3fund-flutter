import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/models/requests/create/create_capital_purchase_request.dart';
import 'package:m3fund_flutter/models/requests/create/create_payment_request.dart';
import 'package:m3fund_flutter/models/responses/campaign_response.dart';
import 'package:m3fund_flutter/models/responses/contributor_response.dart';
import 'package:m3fund_flutter/screens/home/campaign_details_screen.dart';
import 'package:m3fund_flutter/screens/home/payment_success_screen.dart';
import 'package:m3fund_flutter/services/capital_purchase_service.dart';
import 'package:m3fund_flutter/services/user_service.dart';
import 'package:m3fund_flutter/tools/utils.dart';
import 'package:remixicon/remixicon.dart';

class InvestmentScreen extends StatefulWidget {
  final CampaignResponse campaign;
  final CreatePaymentRequest payment;
  const InvestmentScreen({
    super.key,
    required this.campaign,
    required this.payment,
  });

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  bool firstConditionChecked = false;
  bool secondConditionChecked = false;
  final UserService _userService = UserService();
  ContributorResponse? _user;
  bool _isLoading = false;
  final CapitalPurchaseService _capitalPurchaseService =
      CapitalPurchaseService();

  _loadUser() async {
    final userReponse = await _userService.me();
    setState(() {
      _user = userReponse;
    });
  }

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.white.withValues(alpha: 0.01),
                surfaceTintColor: Colors.transparent,
                toolbarHeight: 50,
                leadingWidth:
                    ((MediaQuery.of(context).size.width - 350) / 2) + 40,
                centerTitle: true,
                title: Text(
                  "Investir dans ${widget.campaign.projectResponse.name}",
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(
                    left: (MediaQuery.of(context).size.width - 350) / 2,
                  ),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(
                      RemixIcons.arrow_left_line,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - 350) / 2,
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(height: 110),
                Text(
                  "Engagement d'Intention d'Investissement et d'Acceptation des Conditions Spécifiques de Financement",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Text(
                  "Le présent engagement d'intention et d'acceptation vaut pour l'enregistrement de la  Contribution sur la Plateforme.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  "Il est entendu que cet engagement sera suivi, dès la clôture réussie de la campagne de finacement, par la conclusion d'un accord ou contrat spécifique et détailllé (Pacte d'Actionnaires, Contrat de Royalties etc.) entre le Contributeur-Investisseur et le Porteur de Projet, conformément à l'Art. 5.b des CGU.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  "Chacune des parties reconnaît la validité de cet égangement et s'engage à respecter les termes et modalités ci dessous.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: BoxBorder.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Détails sur l'investissement",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          spacing: 8,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Projet",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  widget.campaign.projectResponse.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Porté par",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  widget.campaign.owner.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Domaine du projet",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  getProjectDomainLabel(
                                    widget.campaign.projectResponse.domain,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            DottedBorder(
                              options: CustomPathDottedBorderOptions(
                                color: Colors.black.withValues(alpha: 0.2),
                                strokeWidth: 2,
                                dashPattern: [5, 5],
                                customPath: (size) => Path()
                                  ..moveTo(0, size.height)
                                  ..relativeLineTo(size.width, 0),
                              ),
                              child: SizedBox(width: double.infinity),
                            ),
                            SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Part en vente",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  "${widget.campaign.shareOffered} %",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Somme",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  "${widget.campaign.targetBudget} FCFA",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Checkbox(
                                  value: firstConditionChecked,
                                  onChanged: (value) {
                                    setState(
                                      () => firstConditionChecked = value!,
                                    );
                                  },
                                  activeColor: primaryColor,
                                  checkColor: Colors.white,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 12),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Je déclare avoir pris connaissance et accepter sans réserve :\n",
                                            ),
                                          ],
                                        ),
                                      ),
                                      _bulletWithLink(
                                        "Les Conditions Générales d’Utilisation – Contributeurs M3Fund en vigueur.",
                                      ),
                                      _bullet(
                                        "Le fait que M3Fund agit uniquement comme intermédiaire technique et n’est pas partie prenante directe aux accords ou contrats spécifiques d’investissement (Art. 5.b).",
                                      ),
                                      _bullet(
                                        "Que cette Contribution est effectuée en pleine connaissance des risques inhérents au financement participatif et d’investissement, M3Fund ne garantissant ni la réussite ni la viabilité du projet (Art. 6).",
                                      ),
                                      _bullet(
                                        "Que les fonds engagés sont soumis aux conditions de l’investissement et que les investissements ne sont pas remboursables en dehors des conditions prévues par le contrat spécifique (Art. 9).",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Checkbox(
                                  value: secondConditionChecked,
                                  onChanged: (value) {
                                    setState(
                                      () => secondConditionChecked = value!,
                                    );
                                  },
                                  activeColor: primaryColor,
                                  checkColor: Colors.white,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "En cliquant sur 'Je signe, ${_user?.firstName ?? "Prénom"} ${_user?.lastName ?? "Nom"}', j'accepte sans réserve ce dit engagement. ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              height: 95,
              width: double.infinity,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 54,
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading ? Colors.white : primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(300, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (!firstConditionChecked && !secondConditionChecked) {
                        showCustomTopSnackBar(
                          context,
                          "Veuillez cocher toutes les case à cocher",
                          color: Colors.redAccent,
                        );
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          final response = await _capitalPurchaseService
                              .createPurchase(
                                campaignId: widget.campaign.id,
                                purchase: CreateCapitalPurchaseRequest(
                                  shareAcquired: widget.campaign.shareOffered,
                                  payment: widget.payment,
                                ),
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentSuccessScreen(
                                payment: response.payment,
                              ),
                            ),
                          );
                        } catch (e) {
                          showCustomTopSnackBar(context, e.toString());
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? SpinKitSpinningLines(color: primaryColor, size: 24)
                        : Text(
                            "Je signe, ${_user?.firstName ?? "Prénom"} ${_user?.lastName ?? "Nom"}",
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bulletWithLink(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("•  "),
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Text(
              text,
              style: TextStyle(
                color: primaryColor,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Puce simple
  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("•  "),
        Expanded(child: Text(text, style: TextStyle(fontSize: 12))),
      ],
    );
  }
}
