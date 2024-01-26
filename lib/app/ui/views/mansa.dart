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

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.80,
                    child: Card(
                      elevation: 12.0,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text("Portefeuille"),
                            const Text(
                              "\$450",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            ListTile(
                              title: const Text("Mon historique"),
                              trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios)),
                            )
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
                                const Column(
                                  children: [
                                    Text("Intérêts"),
                                    Text(
                                      "\$4",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                    onPressed: (){},
                                    child: const Row(
                                      children: [
                                        Text("Mes coupons"),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    ))
                              ],
                            ),
              
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: (){},
                                    child: const Row(
                                      children: [
                                        Text("Dépôt"),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    )
                                ),
                                TextButton(
                                    onPressed: (){},
                                    child: const Row(
                                      children: [
                                        Text("Retrait"),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    )
                                )
                              ],
                            )
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
      ),
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

