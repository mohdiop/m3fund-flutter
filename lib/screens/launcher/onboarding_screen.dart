import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m3fund_flutter/constants.dart';
import 'package:m3fund_flutter/screens/auth/login_screen.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageViewController = PageController();
  int _currentPageIndex = 0;
  bool get isFirstPage => _currentPageIndex == 0;
  bool get isLastPage => _currentPageIndex == 2;
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isAtBottom = true;
        });
      } else {
        _isAtBottom = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          leadingWidth: 110,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 100,
                height: 38,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isFirstPage ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: isFirstPage
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      spacing: 10,
                      children: [
                        if (_currentPageIndex == 0) ...[
                          Icon(
                            RemixIcons.global_line,
                            color: Colors.white,
                            size: 24,
                          ),
                          const Text(
                            "fr",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            RemixIcons.arrow_down_s_line,
                            color: Colors.white,
                            size: 24,
                          ),
                        ] else ...[
                          // Return to previous page button
                          IconButton(
                            onPressed: () {
                              if (_currentPageIndex == 2) {
                                _pageViewController.animateToPage(
                                  1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              } else if (_currentPageIndex == 1) {
                                _pageViewController.animateToPage(
                                  0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: const CircleBorder(),
                            ),
                            icon: Icon(
                              RemixIcons.arrow_left_line,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            // Skip Icon Button
            if (_currentPageIndex != 2)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    _pageViewController.animateToPage(
                      2,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    RemixIcons.skip_right_line,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          children: [
            Column(
              spacing: 10,
              children: [
                Image.asset("assets/bdi.png", width: 260),
                Image.asset("assets/onboarding1.png", width: 260),
                SizedBox(
                  width: 300,
                  child: Text(
                    "Découvrez des projets innovants qui ont besoin de financement que ça soit par bénévolat, don ou investissement pour voir le jour.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Column(
              spacing: 10,
              children: [
                Image.asset("assets/bdi.png", width: 260),
                Image.asset("assets/onboarding2.png", width: 260),
                SizedBox(
                  width: 300,
                  child: Text(
                    "Faites des dons, des bénévolats et des investissements afin de permettre à ces projets de vivre ou de continuer à vivre. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(primaryColor),
                trackColor: WidgetStateProperty.all(f4Grey),
                trackBorderColor: WidgetStateProperty.all(Colors.transparent),
                thickness: WidgetStateProperty.all(6),
                radius: const Radius.circular(8),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Center(
                          child: Text(
                            "Conditions Générales d’Utilisation – Contributeurs M3Fund",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      _sectionTitle("1 – Objet"),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Les présentes Conditions Générales d’Utilisation (ci-après « CGU ») ont pour objet de définir les droits et obligations des utilisateurs ayant le statut de contributeurs (donateurs, investisseurs ou bénévoles) de la plateforme ",
                            ),
                            TextSpan(
                              text: "M3Fund",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ", accessible à l’adresse www.m3fund.com et via les applications mobiles associées.\n\nM3Fund est une plateforme numérique de financement participatif localisé, permettant aux citoyens, entreprises et associations de soutenir des projets à impact social, économique ou communautaire au Mali et dans la diaspora.",
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("2 – Définitions"),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "Plateforme : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "désigne le site web et/ou les applications M3Fund.\n",
                            ),
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "Contributeur : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "toute personne physique ou morale souhaitant soutenir un projet publié sur M3Fund, par don, investissement ou bénévolat.\n",
                            ),
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "Porteur de projet : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "toute personne physique ou morale ayant publié un projet sur la plateforme.\n",
                            ),
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "Contribution : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "désigne tout don, investissement financier ou engagement bénévole effectué via la plateforme.\n",
                            ),
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "Compte utilisateur : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "espace personnel permettant au contributeur d’accéder à ses informations, son historique et ses contributions.\n",
                            ),
                            TextSpan(text: "• "),
                            TextSpan(
                              text: "M3Fund : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "la société ou structure éditrice de la plateforme, opérant depuis le Mali.",
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("3 – Acceptation des conditions"),
                      const Text(
                        "L’utilisation de la plateforme M3Fund implique l’acceptation pleine et entière des présentes CGU. Toute création de compte vaut acceptation des termes et conditions en vigueur à la date d’inscription.\n\n"
                        "M3Fund se réserve le droit de modifier les présentes CGU à tout moment, les nouvelles dispositions s’appliquant dès leur mise en ligne.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("4 – Accès à la plateforme"),
                      const Text(
                        "L’accès à la plateforme est libre et gratuit pour la consultation des projets. Toutefois, certaines fonctionnalités nécessitent la création d’un compte (contribution, messagerie, suivi de projet, etc.).\n\n"
                        "Le contributeur s’engage à fournir des informations exactes, à jour et complètes lors de son inscription, et à les maintenir à jour en cas de modification.\n\n"
                        "M3Fund ne pourra être tenue responsable en cas de fausse déclaration ou d’informations erronées fournies par l’utilisateur.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("5 – Types de contribution"),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "a) Don : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "Le donateur effectue un versement volontaire et irrévocable sans contrepartie financière. Des contreparties symboliques peuvent être proposées par le porteur du projet (remerciements, produits symboliques, etc.) mais ne constituent pas une obligation contractuelle.\n\n",
                            ),
                            TextSpan(
                              text:
                                  "b) Investissement (Equity ou Royalties) : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "L’investisseur contribue au financement d’un projet en échange soit d’une participation au capital (equity), soit d’un pourcentage du chiffre d’affaires futur (royalties), selon les conditions précisées sur la page du projet. Les opérations d’investissement sont encadrées par des accords ou contrats spécifiques conclus entre le porteur et les investisseurs, dont M3Fund n’est pas partie prenante directe. M3Fund agit uniquement comme intermédiaire technique.\n\n",
                            ),
                            TextSpan(
                              text: "c) Bénévolat : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "Le bénévole propose ses compétences, son temps ou ses ressources pour accompagner un projet. Aucune rémunération ni contrepartie financière n’est due en échange de l’engagement bénévole.",
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("6 – Responsabilité de M3Fund"),
                      const Text(
                        "M3Fund agit comme plateforme d’intermédiation et ne garantit pas la réussite des campagnes de financement, la bonne exécution ou la viabilité des projets financés, ni la conformité ou l’exactitude des informations fournies par les porteurs.\n\n"
                        "Toute contribution est effectuée en pleine connaissance des risques inhérents au financement participatif.\n\n"
                        "M3Fund assure néanmoins la transparence des transactions, la sécurisation des paiements via ses prestataires agréés (Mobile Money, CinetPay, PayDunya…), et la modération des contenus publiés.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("7 – Obligations du contributeur"),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Le contributeur s’engage à :\n"),
                            TextSpan(
                              text:
                                  "• n’utiliser la plateforme qu’à des fins licites ;\n",
                            ),
                            TextSpan(
                              text: "• ne pas usurper l’identité d’autrui ;\n",
                            ),
                            TextSpan(
                              text:
                                  "• ne pas diffuser de contenus injurieux, diffamatoires, racistes ou contraires à la loi ;\n",
                            ),
                            TextSpan(
                              text:
                                  "• respecter les montants et modalités des contributions effectuées ;\n",
                            ),
                            TextSpan(
                              text:
                                  "• effectuer les paiements uniquement via les moyens autorisés par la plateforme.\n\n",
                            ),
                            TextSpan(
                              text:
                                  "Tout manquement à ces obligations pourra entraîner la suspension ou suppression du compte sans préavis.",
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("8 – Paiements et commissions"),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Les paiements sont effectués via les solutions sécurisées intégrées à la plateforme.\n\n",
                            ),
                            TextSpan(
                              text: "M3Fund prélève une commission fixe de 5% ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  "sur le montant de chaque transaction effectuée sur la plateforme, en contrepartie des services d’intermédiation et de maintenance du système.\n\n",
                            ),
                            TextSpan(
                              text:
                                  "Des frais supplémentaires liés aux prestataires de paiement (Mobile Money, CinetPay, etc.) peuvent également s’appliquer selon le mode de paiement utilisé.",
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("9 – Droit de rétractation"),
                      const Text(
                        "Étant donné la nature participative et immédiate des contributions :\n"
                        "• les dons ne sont pas remboursables ;\n"
                        "• les investissements sont soumis aux conditions du contrat spécifique entre les parties ;\n"
                        "• les bénévolats peuvent être annulés avant le début de la mission, sans pénalité.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("10 – Protection des données personnelles"),
                      const Text(
                        "M3Fund collecte et traite les données des contributeurs conformément à la loi malienne sur la protection des données personnelles.\n\n"
                        "Les données collectées (identité, contact, historique de contribution, etc.) sont utilisées exclusivement pour la gestion du compte, la mise en relation avec les porteurs et la conformité réglementaire (KYC, lutte anti-blanchiment).\n\n"
                        "Aucune donnée personnelle ne sera vendue ni transmise à des tiers sans consentement explicite.\n\n"
                        "Le contributeur peut à tout moment demander la suppression de son compte, ou exercer ses droits d’accès, de rectification et d’opposition via l’adresse : mohdiopcode@gmail.com.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("11 – Propriété intellectuelle"),
                      const Text(
                        "Tous les éléments du site M3Fund (textes, logos, charte graphique, contenu éditorial) sont protégés par les droits d’auteur et demeurent la propriété exclusive de la plateforme.\n\n"
                        "Toute reproduction, diffusion ou utilisation non autorisée est interdite.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle("12 – Suspension ou résiliation du compte"),
                      const Text(
                        "M3Fund se réserve le droit de suspendre ou supprimer le compte d’un contributeur en cas de violation des CGU, de comportement frauduleux, ou de non-respect des lois en vigueur.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      _divider(),
                      _sectionTitle(
                        "13 – Droit applicable et juridiction compétente",
                      ),
                      const Text(
                        "Les présentes CGU sont régies par le droit malien. Tout litige relatif à leur interprétation ou leur exécution sera soumis à la compétence exclusive des tribunaux maliens.\n\n"
                        "Entrée en vigueur : les présentes CGU sont applicables à compter du 01 Novembre 2025.",
                        style: TextStyle(fontSize: 15, height: 1.5),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              height: 100,
              width: double.infinity,
              child: Column(
                spacing: 10,
                children: [
                  Column(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageViewController,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor: secondaryColor,
                          dotColor: Colors.grey.shade300,
                          dotHeight: 10,
                          dotWidth: 30,
                          spacing: 15,
                        ),
                        onDotClicked: (index) {
                          _pageViewController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: Size(300, 62),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: (!_isAtBottom && _currentPageIndex == 2)
                        ? null
                        : () async {
                            if (_currentPageIndex == 0) {
                              _pageViewController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else if (_currentPageIndex == 1) {
                              _pageViewController.animateToPage(
                                2,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool("isFirstTime", false);
                              if (!context.mounted) return;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            }
                          },
                    child: isLastPage
                        ? Text("Commencer", style: TextStyle(fontSize: 24))
                        : Text("Suivant", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Divider(thickness: 1),
  );
}
