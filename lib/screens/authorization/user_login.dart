import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/user_model.dart';
import 'package:organizerPRO/screens/authorization/password_reset.dart';
import 'package:organizerPRO/screens/dashboard_view.dart';
import 'package:organizerPRO/services/auth_service.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({Key? key}) : super(key: key);

  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  final formKey = GlobalKey<FormState>();
  final formServerKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isLoading = false;
  String? emailInput = "";
  String? passInput = "";

  // Error feedback
  String errorFeedback = "";

  //Funkcja logująca użytkownika
  void loginUser() async {
    setState(() => isLoading = true);
    UserLogin data = UserLogin(email: emailInput, pass: passInput);
    Response? response = await UserApiService().login(data);
    setState(() {
      if (response != null) {
        isLoading = false;
        if (response.statusCode == 200) {
          storage.write(key: "token", value: response.data);
          var payload = Jwt.parseJwt(response.data);
          storage.write(
              key: "userName",
              value: payload[
                  "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DashboardPanel()));
        }
        if (response.statusCode == 400) {
          errorFeedback = "Podano nieprawidłowe dane logowania!";
        } else {
          errorFeedback = "Coś poszło nie tak, spróbuj jeszcze raz!";
        }
      } else {
        errorFeedback = "Wystąpił problem połączenia internetowego";
        isLoading = false;
      }
    });
  }

  //Funkcja walidująca adres e-mail podany przez użytkownika
  String? emailValidation(String? value) {
    bool validation = RegExp(
            r'(?![_.-])((?![_.-][_.-])[a-zA-Z\d_.-]){0,63}[a-zA-Z\d]@((?!-)'
            r'((?!--)[a-zA-Z\d-]){0,63}[a-zA-Z\d]\.){1,2}([a-zA-Z]{2,14}\.)?[a-zA-Z]{2,14}')
        .hasMatch(value!);
    if (value.isEmpty) {
      return "Proszę podać adres e-mail!";
    } else if (!validation) {
      return "Proszę podać prawidłowy adres e-mail!";
    }
    return null;
  }

  //Funkcja pokazująca AlertDialog z wyborem adresu serwera
  void showAppSettings() {
    bool isSwitched = false;
    String? serverIp = "";
    String? emulatorIp = "http://10.0.2.2:5151";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              titlePadding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
              contentPadding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: const Text("Ustawienia serwera"),
              content: SizedBox(
                  height: 280,
                  width: 300,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Tryb deweloperski",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: secondColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Emulator",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Połącz się z serwerem lokalnym",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: fontGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      if (isSwitched) SERVER_IP = emulatorIp;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Adres serwera",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: secondColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (!isSwitched) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                ("Podaj adres serwera"),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ("Wpisz adres serwera docelowego"),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: fontGrey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: formServerKey,
                            child: TextFormField(
                                initialValue: SERVER_IP,
                                onSaved: (value) {
                                  serverIp = value;
                                },
                                cursorColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    hintText: "Adres serwera",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'To pole nie może być puste!';
                                  }
                                  return null;
                                }),
                          ),
                        ] else ...[
                          TextFormField(
                            initialValue: emulatorIp,
                            onSaved: (value) {
                              serverIp = value;
                            },
                            readOnly: true,
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                hintText: "Adres serwera",
                                fillColor: bg35Grey,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ],
                      ])),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deleteBtn,
                          foregroundColor: bgSmokedWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text("Anuluj")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: bgSmokedWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          if (!isSwitched &&
                              formServerKey.currentState!.validate()) {
                            formServerKey.currentState!.save();
                            SERVER_IP = serverIp!;
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Zapisz zmiany")),
                  ],
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () async {
                        showAppSettings();
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Center(
                        child: Image(
                          width: 200,
                          height: 200,
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                        child: Text(
                          "Logowanie",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                validator: emailValidation,
                                onSaved: (String? value) {
                                  emailInput = value;
                                },
                                cursorColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.alternate_email,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wprowadź email...",
                                    fillColor: bgSmokedWhite,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: isObscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Proszę podać hasło";
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  passInput = value;
                                },
                                cursorColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() {
                                        isObscure = !isObscure;
                                      }),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 1, 15, 0),
                                      icon: Icon(
                                        isObscure
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.fingerprint,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wprowadź hasło...",
                                    fillColor: bgSmokedWhite,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (errorFeedback.isNotEmpty) ...[
                                Text(
                                  errorFeedback,
                                  style: const TextStyle(
                                      color: errorColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.2),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: mainColor,
                                        backgroundColor: mainColor,
                                        disabledForegroundColor:
                                            Colors.amber.withOpacity(0.38),
                                        disabledBackgroundColor:
                                            Colors.amber.withOpacity(0.12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        errorFeedback = "";
                                        loginUser();
                                      }
                                    },
                                    icon: isLoading
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            padding: const EdgeInsets.all(2),
                                            child:
                                                const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.login,
                                            color: bgSmokedWhite,
                                          ),
                                    label: const Text(
                                      "Zaloguj się",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: bgSmokedWhite),
                                    )),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: fontBlack,
                                  disabledForegroundColor:
                                      secondColor.withOpacity(0.38),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PasswordReset(),
                                    ));
                              },
                              child: const Text("Nie pamiętam hasła"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Nie masz konta?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: fontBlack,
                                  disabledForegroundColor:
                                      secondColor.withOpacity(0.38),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/registerUser',
                                );
                              },
                              child: const Text("Zarejestruj się"))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text("Czy na pewno chcesz wyjść z\u{00A0}aplikacji? "),
          content: const Text("Mamy nadzieję, że zaraz tutaj wrócisz!"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: mainColor, backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "Anuluj",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: deleteBtn, backgroundColor: deleteBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Wyjdź",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      },
    );
    return exit;
  }
}
