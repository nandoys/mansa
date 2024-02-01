import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:mansa/registration/models/models.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mansa/utils/utils.dart';
import 'package:mansa/app/ui/views/mansa.dart';

class AuthentificationPage extends StatefulWidget {
  AuthentificationPage({super.key});

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  TextEditingController phoneNumberController = TextEditingController();
  String? country = 'CD';
  String? countryDialCode = '+243';
  bool isLoading = false;
  bool isValidNumber = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onChangedCountry(CountryCode? countryCode) {
    if(countryCode != null) {
      setState(() {
        country = countryCode.code;
        countryDialCode = countryCode.dialCode;
      });
    }
  }

  String? phoneValidation(String? number) {
    if (number!.isEmpty) {
      return "Numéro de téléphone obligatoire";
    }
    return null;
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    setState(() {
      isLoading = false;
    });
    try {
      final User? user = (await widget._auth.signInWithCredential(credential)).user;
      if(user != null) {
        // TODO: save the user locally

        PageRoute route = MaterialPageRoute(
            builder: (context) => RegistrationPage(uuid: user.uid, phoneNumber: phoneNumberController.text,)
        );

        final document = await widget._db.collection("accounts").doc(user.uid).get();
        if (document.exists) {
          final account = Account.fromMap(document.data()!);
          route = MaterialPageRoute(
              builder: (context) => Mansa(account: account,)
          );
        }

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
      }
    } catch(error) {
      print(error.runtimeType);
    }

  }

  void verificationFailed(FirebaseAuthException error) {
    setState(() {
      isLoading = false;
    });
    //network-request-failed
    showSnackbar(context, error.message.toString());
  }

  void codeSent(String verificationId, int? forceResendingToken) {
    setState(() {
      isLoading = false;
    });

    String phoneNumber = "$countryDialCode${phoneNumberController.text}";
    final route = MaterialPageRoute(
        builder: (context) => VerificationCode(
          phoneNumber: phoneNumber, verificationId: verificationId, resendToken: forceResendingToken
        )
    );
    Navigator.of(context).push(route);
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('my timeout-------------------------------');
    print(verificationId);
    print('my timeout-------------------------------');
  }

  void onChangedNumber(value) {
    if (formKey.currentState!.validate()) {
      setState(() {
        isValidNumber = true;
      });
    } else {
      if (isValidNumber) {
        setState(() {
          isValidNumber = false;
        });
      }
    }
  }

  void sendSMS() {
    if (formKey.currentState!.validate()) {
      String phoneNumber = "$countryDialCode${phoneNumberController.text}";
      setState(() {
        isLoading = true;
      });
      try {
        widget._auth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
        );
      } on FirebaseAuthException catch (error) {
        setState(() {
          isLoading = false;
        });
        showSnackbar(context, error.message.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Tout commence par un pas',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                SizedBox(
                  width: 500,
                  height: 300,
                  child: FittedBox(
                    child: Image.asset('assets/images/auth-illustration.png'),
                  ),
                ),
                const Text(
                  'Entrez votre numéro pour recevoir un SMS de confirmation',
                  style: TextStyle(
                      color: Colors.white70
                  ),
                ),
                Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  const SizedBox(width: 5,),
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
                                autofocus: true,
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: ValidationBuilder(requiredMessage: "Numéro requis").
                                regExp(RegExp(r'^[0-9]+$'), 'Numéro invalide').maxLength(
                                    9, "Entrez 9 chiffres"
                                ).minLength(
                                    9, "Entrez 9 chiffres"
                                ).build(),
                                onChanged: onChangedNumber,
                                decoration: InputDecoration(
                                  hintText: "Numéro de téléphone",
                                  hintStyle: TextStyle(
                                      color: Colors.yellow.shade700
                                  ),
                                  suffixIcon: isValidNumber ? const Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ) : null
                                ),
                                style: const TextStyle(
                                    color: Colors.white
                                ),
                              )
                          )
                        ],
                      ),
                    )
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)
                        ),
                        onPressed: isLoading ? null : sendSMS,
                        child: isLoading ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) :
                        const Text(
                          'Créer un compte',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}


class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key, required this.uuid, required this.phoneNumber});

  // final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final String uuid;
  final String phoneNumber;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  File? image;
  bool loadingImage = false;
  List<String> genders = <String>['Homme', 'Femme'];
  // List<String> idDocuments = <String>['Carte nationale', 'Passeport', 'Permis de conduire'];
  String? genderValue;
  bool isLoading = false;
  late DateTime birthday;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();


  void onChangedGender(String? value) {
    setState(() {
      genderValue = value;
    });
  }

  void pickDate() async {
    final dateValue = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        currentDate: birthday,
        locale: const Locale("fr"),
        firstDate: DateTime(1924),
        lastDate: DateTime(majorAge(),12,31),
    );

    if (dateValue != null) {
      setState(() {
        birthday = dateValue;
      });
    }

  }

  int majorAge() {
    final year = DateTime.now().year;
    return year - 18;
  }

  void pickImage() async {
    setState(() {
      loadingImage = true;
    });
    image = await openGallery(context);
    setState(() {
      loadingImage = false;
    });
  }

  Future<String?> storeFileToStorage() async {
    String? downloadUrl;

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'file-path': image!.path},
    );

    UploadTask uploadTask = widget._storage.ref().child("profile/${widget.uuid}").putFile(image!, metadata);
    TaskSnapshot snapshot = await uploadTask;
    downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      if (image == null) {
        showSnackbar(context, "Veuillez ajouter votre photo");
        return;
      }
      setState(() {
        isLoading = true;
      });

      Account account = Account(
          uuid: widget.uuid,
          name: nameController.text.trim(),
          firstname: firstnameController.text.trim(),
          gender: genderValue as String,
          birthday: birthday,
          phoneNumber: widget.phoneNumber,
          photo: '',
          createAt: DateTime.now(),
          accountType: "standard"
      );

      try {
        await storeFileToStorage().then((photoUrl) {
          if (photoUrl != null) {
            account.photo = photoUrl;
          }
        });

        await widget._db.collection("accounts").doc(widget.uuid).set(account.toMap()).then((document) {
          setState(() {
            isLoading = false;
          });

          final route = MaterialPageRoute(
              builder: (context) => Mansa(account: account,)
          );

          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);

        });

      } catch (error) {
        setState(() {
          isLoading = false;
        });

      }
    }
  }

  Future<void> checkUserAccount() async {
    final data = await widget._db.collection("accounts").doc(widget.uuid).get();

  }

  @override
  void initState() {
    birthday = DateTime(majorAge());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy', 'fr').format(birthday);
    birthDayController.text = formattedDate;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Complétez votre identité',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 15.0,),
                InkWell(
                  onTap: loadingImage || isLoading ? null : pickImage,
                  child: image == null ? CircleAvatar(
                    radius: 80.0,
                    child: loadingImage ? CircularProgressIndicator(
                      color: Colors.yellow.shade700,
                    ) : const Icon(
                      Icons.person,
                      size: 80.0,
                    ),
                  ) : CircleAvatar(
                    radius: 80.0,
                    backgroundImage: FileImage(File(image!.path)),
                    child: loadingImage ? CircularProgressIndicator(
                      color: Colors.yellow.shade700,
                    ) : null,
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: nameController,
                            validator: ValidationBuilder(requiredMessage: "Ce champ est réquis").build(),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: firstnameController,
                            validator: ValidationBuilder(requiredMessage: "Ce champ est réquis").build(),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            onChanged: onChangedGender,
                            decoration: const InputDecoration(
                                labelText: "Sexe",
                                isDense: false
                            ),
                            validator: ValidationBuilder(requiredMessage: "Ce champ est réquis").build(),
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: birthDayController,
                            validator: ValidationBuilder(requiredMessage: "Ce champ est réquis").build(),
                            decoration: const InputDecoration(
                                labelText: "Date de naissance"
                            ),
                            readOnly: true,
                            onTap: pickDate,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.yellow.shade700)
                        ),
                        onPressed: isLoading || loadingImage ? null : register,
                        child: isLoading ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) :
                        const Text(
                          'Enregistrer',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    firstnameController.dispose();
    birthDayController.dispose();
    super.dispose();
  }
}


class VerificationCode extends StatefulWidget {
  VerificationCode({super.key, required this.phoneNumber, required this.verificationId, required this.resendToken});

  final String phoneNumber;
  final String verificationId;
  final int? resendToken;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {

  String? verificationId;
  int? resendToken;
  bool isLoading = false;

  void onCompleted(String value) async {

    setState(() {
      isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId ?? widget.verificationId,
          smsCode: value
      );

      final User? user = (await widget._auth.signInWithCredential(credential)).user;

      if (user != null) {
        // TODO: save the user locally

        PageRoute route = MaterialPageRoute(
            builder: (context) => RegistrationPage(uuid: user.uid, phoneNumber: widget.phoneNumber,)
        );

        final document = await widget._db.collection("accounts").doc(user.uid).get();
        if (document.exists) {
          final account = Account.fromMap(document.data()!);
          route = MaterialPageRoute(
              builder: (context) => Mansa(account: account,)
          );
        }

        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return; // check if state is mounted, because this is a async function
      showSnackbar(context, error.message.toString());
    }

  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    setState(() {
      isLoading = false;
    });
    try {
      final User? user = (await widget._auth.signInWithCredential(credential)).user;
      if(user != null) {
        // TODO: save the user locally

        PageRoute route = MaterialPageRoute(
            builder: (context) => RegistrationPage(uuid: user.uid, phoneNumber: widget.phoneNumber,)
        );

        final document = await widget._db.collection("accounts").doc(user.uid).get();
        if (document.exists) {
          final account = Account.fromMap(document.data()!);
          route = MaterialPageRoute(
              builder: (context) => Mansa(account: account,)
          );
        }
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
      }
    } catch(error) {
      print(error.runtimeType);
    }

  }

  void verificationFailed(FirebaseAuthException error) {
    setState(() {
      isLoading = false;
    });
    //network-request-failed
    showSnackbar(context, error.message.toString());
  }

  void codeSent(String vId, int? forceResendingToken) {
    setState(() {
      verificationId = vId;
      resendToken = forceResendingToken;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {}

  void resend() {
    try {
      widget._auth.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          forceResendingToken: resendToken ?? widget.resendToken
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, error.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Vérification du numéro de téléphone",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 400,
                  height: 300,
                  child: FittedBox(
                    child: Image.asset('assets/images/enter-otp.png'),
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
                        width: constraints.maxWidth * 0.70,
                        child: PinCodeTextField(
                          length: 6,
                          appContext: context,
                          pinTheme: PinTheme(
                              inactiveColor: Colors.yellow.shade700,
                              selectedColor: Colors.white,
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          textStyle: const TextStyle(
                              color: Colors.white
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.number,
                          autoFocus: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 5.0,);
                          },
                          onCompleted: onCompleted,
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
                        onPressed: isLoading ? null : resend,
                        child: Text(
                          "Renvoyer",
                          style: TextStyle(
                              color: Colors.yellow.shade700
                          ),
                        )
                    )
                  ],
                ),
                if(isLoading) CircularProgressIndicator(
                  color: Colors.yellow.shade700,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
