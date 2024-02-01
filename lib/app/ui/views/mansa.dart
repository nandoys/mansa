import 'dart:math';

import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';

class Mansa extends StatefulWidget {
  const Mansa({super.key});

  @override
  State<Mansa> createState() => _MansaState();
}

class _MansaState extends State<Mansa> {
  List<BottomNavigationBarItem> navigations = [
    const BottomNavigationBarItem(
        icon:Icon(Icons.home), label: "",
    ),
    const BottomNavigationBarItem(
        icon:Icon(Icons.wallet), label: "",
    ),
    const BottomNavigationBarItem(
      icon:Icon(Icons.person), label: "",
    ),
  ];

  List<Widget> views = const [
    DashBoard(),
    Wallet(),
    Profile()
  ];
  Widget? view;
  int selectedNavigationIndex = 0;

  void selectedNavigation(int index) {
    setState(() {
      selectedNavigationIndex = index;
      view = views[index];
    });
  }

  @override
  void initState() {
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
      ),
      body: view,
      bottomNavigationBar: BottomNavigationBar(
          onTap: selectedNavigation,
          currentIndex: selectedNavigationIndex,
          selectedItemColor: Colors.yellow.shade700,
          items: navigations
      ),
    );
  }
}


class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

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

  final List<Widget> _tabViews = [
    const Placeholder(child: Text("data 1"),),
    const Placeholder(child: Text("data 2"),),
    const Placeholder(child: Text("data 3"),),
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
                      child: Icon(Icons.swap_horiz_outlined),
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
            const Text(
              "CARDHOLDER NAME",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16.0
              ),
            )
          ],
        ),
      ),
    );
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
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('Profile', style: TextStyle(color: Colors.white),),
    );
  }
}


class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text("Wallet", style: TextStyle(color: Colors.white),),
    );
  }
}

