import 'dart:math';

import 'package:awesome_card/awesome_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mansa/app/ui/widgets/dashboard_widgets.dart';
import 'package:mansa/main.dart';
import 'package:mansa/registration/models/models.dart';
import 'package:mansa/utils/utils.dart';

class Mansa extends StatefulWidget {
  Mansa({super.key, required this.account});
  final _auth = FirebaseAuth.instance;
  final Account account;

  @override
  State<Mansa> createState() => _MansaState();
}

class _MansaState extends State<Mansa> {
  List<BottomNavigationBarItem> navigations = [
    const BottomNavigationBarItem(
      icon:Icon(Icons.home),
      label: "Accueil",
    ),
    const BottomNavigationBarItem(
      icon:Icon(Icons.person), label: "Profil",
    ),
  ];
  bool isFloatButtonShown = false;

  late List<Widget> views;
  Widget? view;
  int selectedNavigationIndex = 0;

  void selectedNavigation(int index) {
    if(index == 1) isFloatButtonShown = false;

    setState(() {
      selectedNavigationIndex = index;
      view = views[index];
    });
  }

  void showFloatButton(bool value) {
    setState(() {
      isFloatButtonShown = value;
    });
  }

  void logout() async {
    try {
      await widget._auth.signOut();
      final route = MaterialPageRoute(
          builder: (context) => HomePage()
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      showSnackbar(context, error.message.toString());
    }
  }

  @override
  void initState() {
    views = [
      DashBoard(showFloatingButton: showFloatButton, account: widget.account,),
      Profile(account: widget.account,)
    ];

    view = views[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Mansa",
          style: TextStyle(
            //color: Colors.yellow.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
        ),
        actions: [
          Tooltip(
            message: "Se déconnecter",
            child: IconButton(
                onPressed: logout,
                icon: const Icon(Icons.exit_to_app)
            ),
          )
        ],
      ),
      body: view,
      floatingActionButton: isFloatButtonShown ? FloatingActionButton(
        onPressed: (){},
        tooltip: "Faire un retrait",
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25.0,
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: selectedNavigation,
          currentIndex: selectedNavigationIndex,
          selectedItemColor: Colors.yellow.shade700,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500
          ),
          items: navigations
      ),
    );
  }
}


class DashBoard extends StatefulWidget {
  const DashBoard({super.key, required this.showFloatingButton, required this.account});
  final void Function(bool) showFloatingButton;
  final Account account;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  final List<Tab> tabs = [
    const Tab(text: "Dépôt",),
    const Tab(text: "Retrait",),
    const Tab(text: "Actif",),
  ];
  late final TabController _tabController;
  late AnimationController _controller;
  Animation<double>? _moveToBack;
  Animation<double>? _moveToFront;
  bool showBackSide = false;
  int tabIndex = 0;

  final List<Widget> _tabViews = [
    const TransactionHistory(),
    const TransactionHistory(),
    const AssetHistory(),
  ];

  void switchCard() {
    setState(() {
      showBackSide = !showBackSide;
    });
}

  Widget _buildCard({required String currency, required double balance}) {
    return Card(
      elevation: 15.0,
      color: Colors.yellow.shade700,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Portefeuille",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                IconButton(
                    onPressed: switchCard,
                    icon: const Tooltip(
                      message: "Changer la dévise",
                      child: Icon(
                        Icons.swap_horiz_outlined,
                      ),
                    )
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/white-chip.png",
                  width: 80,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Text(
                      "$currency $balance",
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${widget.account.firstname.toUpperCase()} ${widget.account.name.toUpperCase()}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTabTaped(int index) {
    if (index == 1) {
      widget.showFloatingButton(true);
    } else {
      widget.showFloatingButton(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _moveToBack = TweenSequence<double>([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeInBack)),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2), weight: 50.0)
    ]).animate(_controller);

    _moveToFront = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {

    if (showBackSide) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.95,
                  child: Stack(
                    children: <Widget>[
                      AwesomeCard(
                        animation: _moveToBack,
                        child: _buildCard(currency: "FC", balance: 5000),
                      ),
                      AwesomeCard(
                        animation: _moveToFront,
                        child: _buildCard(currency: "\$", balance: 500),
                      ),
                    ],
                  ),
                ),

                TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.yellow.shade700,
                    labelColor: Colors.yellow.shade700,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                    onTap: onTabTaped,
                    tabs: tabs
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: constraints.maxHeight * 0.68,
                  child: TabBarView(
                      controller: _tabController,
                      children: _tabViews
                  )
                )
              ],
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tabController.dispose();
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key, required this.account});
  final Account account;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isIdCardVerify = true;
  bool isProofOfAddressVerify = true;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.account.photo),
                  maxRadius: 80.0,
                ),
                InkWell(
                  onTap: (){},
                  child: const ListTile(
                    title: Text("Informations personnelles"),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                const ListTile(
                  title: Text(
                    "KYC",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text(
                      "Conformité avec les documents légaux"
                  ),
                ),
                InkWell(
                  onTap: isIdCardVerify? null : (){},
                  child: ListTile(
                    title: const Text("Carte d'identité"),
                    trailing: isIdCardVerify ? const Icon(
                      Icons.verified,
                      color: Colors.green,
                    ) : const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
                InkWell(
                  onTap: isProofOfAddressVerify ? null : (){},
                  child: ListTile(
                    title: const Text("Preuve d'adresse"),
                    trailing: isProofOfAddressVerify ? const Icon(
                      Icons.verified,
                      color: Colors.green,
                    ) : const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}


