import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  List<String> genders = <String>['Homme', 'Femme'];
  List<String> idDocuments = <String>['Carte nationale', 'Passeport', 'Permis de conduire'];
  String? genderValue;
  String? idDocumentValue;
  DateTime birthday = DateTime(2006);
  String? country = 'CD';
  String? countryDialCode = '+243';
  TextEditingController birthDayController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();


  void onChangedGender(String? value) {
    setState(() {
      genderValue = value;
    });
  }

  void onChangedCountry(CountryCode? countryCode) {
    if(countryCode != null) {
      setState(() {
        country = countryCode.code;
        countryDialCode = countryCode.dialCode;
      });
    }
  }

  void onChangedIdDocument(String? value) {
    setState(() {
      idDocumentValue = value;
    });
  }

  void pickDate() async {
    final dateValue = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        currentDate: birthday,
        firstDate: DateTime(1924),
        lastDate: DateTime(2006,12,31),
    );

    if (dateValue != null) {
      setState(() {
        birthday = dateValue;
      });
    }

  }

  void verifyPhoneNumber() {
    String phoneNumber = "$countryDialCode${phoneNumberController.text}";
    final route = MaterialPageRoute(builder: (context) => VerificationCode(phoneNumber: phoneNumber));

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    String formatedDate = DateFormat('dd-MM-yyyy', 'fr').format(birthday);
    birthDayController.text = formatedDate;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Commencez votre inscription',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
            ),
            Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Nom de famille",
                        ),
                        style: const TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Prénom",
                        ),
                        style: const TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField(
                        onChanged: onChangedGender,
                        decoration: const InputDecoration(
                          labelText: "Sexe",
                          isDense: false
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return genders.map((String value) {
                            return Text(
                              genderValue ?? '',
                              style: const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        items: genders.map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                                value,
                                style: const TextStyle(
                                    color: Colors.black
                                )
                            )
                        )).toList(),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: birthDayController,
                        onTap: pickDate,
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          labelText: "Date de naissance"
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        children: [
                          CountryListPick(
                            appBar: AppBar(
                              leading: BackButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                                ),
                              ),
                              backgroundColor: Colors.yellow.shade700,
                              title: const Text('Choisir un pays', style: TextStyle(color: Colors.white),),
                            ),
                            theme: CountryTheme(
                                searchText: "Recherche",
                                searchHintText: "Écrire ici...",
                                lastPickText: "Choix actuel",
                                alphabetSelectedBackgroundColor: Colors.yellow.shade700,
                                isShowFlag: true,
                                isShowCode: true,
                                isShowTitle: false,
                                showEnglishName: false
                            ),
                            initialSelection: country,
                            pickerBuilder: (context, CountryCode? countryCode){
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      countryCode?.flagUri ?? '',
                                      package: 'country_list_pick',
                                    ),
                                  ),
                                  Text(
                                      countryCode?.dialCode ?? '',
                                    style: TextStyle(
                                      color: Colors.yellow.shade700
                                    ),
                                  ),
                                ],
                              );
                            },
                            onChanged: onChangedCountry,
                            useSafeArea: true,
                            useUiOverlay: true,
                          ),
                          Expanded(
                              child: TextFormField(
                                controller: phoneNumberController,
                                decoration: const InputDecoration(
                                  labelText: "Numéro de téléphone"
                                ),
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)
                            ),
                            onPressed: verifyPhoneNumber,
                            child: const Text(
                                'Créer un compte',
                              style: TextStyle(color: Colors.white),
                            )
                        ),
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    birthDayController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}


class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void resend() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Vérification du numéro de téléphone",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Entrez le code envoyé au ",
                  style: TextStyle(
                    color: Colors.white70
                  ),
                ),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth * 0.50,
                    child: PinCodeTextField(
                      length: 6,
                      appContext: context,
                      pinTheme: PinTheme(
                        inactiveColor: Colors.yellow.shade700
                      ),
                      cursorColor: Colors.white,
                      autoFocus: true,
                    ),
                  );
                }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Vous n'avez pas reçu de code ? ",
                  style: TextStyle(
                      color: Colors.white70
                  ),
                ),
                TextButton(
                    onPressed: resend,
                    child: Text(
                      "Renvoyer",
                      style: TextStyle(
                        color: Colors.yellow.shade700
                      ),
                    )
                )
              ],
            ),
            ElevatedButton(
                onPressed: (){},
                child: const Text(
                  "Vérifier",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
