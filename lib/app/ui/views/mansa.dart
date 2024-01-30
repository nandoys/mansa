import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.95,
                  child: Card(
                    elevation: 15.0,
                    color: Colors.yellow.shade700,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text(
                              "Portefeuille",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/white-chip.png",
                                width: 80,
                              ),
                              const Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        "FC 45 000 000 000",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          "|",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\$ 450",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                  width: constraints.maxWidth * 0.80,
                  child: Card(
                    elevation: 12.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sponsorisé")
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(50, (index) {
                                return const SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Card(
                                    child: Text("OKKK"),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.80,
                  child: Card(
                    elevation: 12.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                  child: Text("Emprunt immobilier")
                              ),
                              Flexible(
                                child: TextButton(
                                    onPressed: (){},
                                    child: const Row(
                                      children: [
                                        Flexible(child: Text("Tous les coupons")),
                                        Expanded(child: Icon(Icons.arrow_forward))
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(50, (index) {
                                return const SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Card(
                                    child: Text("OKKK"),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
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

