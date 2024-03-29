import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mansa/app/ui/views/mansa.dart';
import 'package:mansa/registration/models/models.dart';
import 'package:mansa/registration/ui/views/registration.dart';

import 'firebase_options.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // Activate app check after initialization, but before
  // usage of any Firebase services.
  // await FirebaseAppCheck.instance
  // // Your personal reCaptcha public key goes here:
  //     .activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  //   webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  // );
  
  await FirebaseAuth.instance.setLanguageCode("fr");
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  ValidationBuilder.setLocale('fr');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mansa',
      theme: ThemeData(
          primaryColor: Colors.yellow.shade700,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.grey.shade900,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.yellow.shade700
          ),
          inputDecorationTheme: const InputDecorationTheme(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
            labelStyle: TextStyle(
                color: Colors.white
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700),
                foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
            ),
            confirmButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700),
              foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
            ),
            todayForegroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade800),
            dayOverlayColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700),

          )
      ),
      darkTheme: ThemeData.dark(
          useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;

  void register() {
    final route = MaterialPageRoute(builder: (context) => AuthentificationPage());
    Navigator.of(context).push(route);
  }

  void showPrivacy() {}

  @override
  void initState() {
    super.initState();

    widget._auth.idTokenChanges().listen((user) {
      if(mounted) {
        setState(() {
          currentUser = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(currentUser != null) {
      return FutureBuilder(
          future: widget._db.collection("accounts").doc(currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow.shade700,
                  ),
                ),
              );
            }

            if (snapshot.data!.exists) {
              final account = Account.fromMap(snapshot.data!.data()!);
              return Mansa(account: account,);
            } else {
              return RegistrationPage(uuid: currentUser!.uid, phoneNumber: currentUser!.phoneNumber!);
            }

          }
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Bienvenue sur',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                SizedBox(
                  width: 600,
                  height: 300,
                  child: FittedBox(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                        child: Text(
                          'Lisez notre ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                    Flexible(
                        flex: 3,
                        child: InkWell(
                          onTap: showPrivacy,
                          child: Text(
                            'politique de confidentialité, ',
                            style: TextStyle(
                              color: Colors.yellow.shade700,
                            ),
                          ),
                        )
                    ),
                    const Flexible(
                        child: Text(
                          "Cliquez sur ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          "Accepter et Continuer pour accepter ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: showPrivacy,
                        child: Text(
                          "les conditions d'utilisation",
                          style: TextStyle(
                            color: Colors.yellow.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: register,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)
                    ),
                    child: const Text(
                      'Accepter et Continuer',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    )
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    "Dévelopé par Gradi Nandoy",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
