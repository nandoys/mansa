import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mansa/registration/ui/views/registration.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
          scaffoldBackgroundColor: Colors.black87,
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade700)
            ),
            labelStyle: const TextStyle(
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
      home: const MyHomePage(title: 'Mansa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    void register() {
      final route = MaterialPageRoute(builder: (context) => const RegistrationForm());
      Navigator.of(context).push(route);
    }

    void showPrivacy() {}

    return Scaffold(
      body: SafeArea(
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
              width: 300,
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
                          fontSize: 8.0
                      ),
                    )
                ),
                Flexible(
                    child: InkWell(
                      onTap: showPrivacy,
                      child: Text(
                        'politique de confidentialité, ',
                        style: TextStyle(
                            color: Colors.yellow.shade700,
                            fontSize: 8.0
                        ),
                      ),
                    )
                ),
                const Flexible(
                    child: Text(
                      "Cliquez sur 'Accepter et Continuer' ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.0
                      ),
                    )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'pour accepter ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.0
                    ),
                  ),
                  InkWell(
                    onTap: showPrivacy,
                    child: Text(
                      "les conditions d'utilisation",
                      style: TextStyle(
                          color: Colors.yellow.shade700,
                          fontSize: 8.0
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
                    fontSize: 10.0
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
