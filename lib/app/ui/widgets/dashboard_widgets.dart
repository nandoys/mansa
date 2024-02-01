import 'package:flutter/material.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
          return ExpansionTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text(
              "Boutique Nandoy",
              style: TextStyle(
                fontWeight: FontWeight.w500
              ),
            ),
            subtitle: const Text("Dépôt agent"),
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "20 USD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text("03:35")
              ],
            ),
            children: [
              Container(
                color: Colors.grey.shade200,
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Numéro Référence"),
                      trailing: Text(
                        "CI240120.1340.A43146",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: (){},
                                icon: CircleAvatar(
                                  backgroundColor: Colors.yellow.shade700,
                                  child: const Icon(Icons.file_download_sharp),
                                )
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                "Voir le reçu",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      itemCount: 10,
    );
  }
}

class AssetHistory extends StatefulWidget {
  const AssetHistory({super.key});

  @override
  State<AssetHistory> createState() => _AssetHistoryState();
}

class _AssetHistoryState extends State<AssetHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ExpansionTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: const Text(
            "Boutique Nandoy",
            style: TextStyle(
                fontWeight: FontWeight.w500
            ),
          ),
          subtitle: const Text("Dépôt agent"),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "20 USD",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text("03:35")
            ],
          ),
          children: [
            Container(
              color: Colors.grey.shade200,
              child: Column(
                children: [
                  const ListTile(
                    title: Text("Vos dividendes"),
                    trailing: Text(
                      "20 USD",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: (){},
                              icon: CircleAvatar(
                                backgroundColor: Colors.yellow.shade700,
                                child: const Icon(Icons.arrow_forward),
                              )
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              "Voir détails",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
      itemCount: 10,
    );
  }
}
