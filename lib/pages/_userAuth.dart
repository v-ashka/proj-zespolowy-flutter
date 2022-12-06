import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/main.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/old_/_dashboard.dart';
import 'package:projzespoloey/pages/password_reset_code.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';

class UserAuthentication extends StatefulWidget {
  const UserAuthentication({Key? key}) : super(key: key);
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  State<UserAuthentication> createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  // Local flutter storage token
  // final storage = new FlutterSecureStorage();
  // Form variables
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isLoading = false;
  String? emailInput = "";
  String? passInput = "";

  // Error feedback
  String errorFeedback = "";

  void saveData() async {
    setState(() => isLoading = true);
    Map<String, dynamic> payload = {};
    UserLogin data = UserLogin(email: emailInput, pass: passInput);
    var token = await UserApiService().login(data);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          print("token is:");
          print(token);
          isLoading = false;

          if (token["data"] != null) {
            var payload = Jwt.parseJwt(token["data"]);
            storage.write(
                key: "userName",
                value: payload[
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]);
            // payload = Jwt.parseJwt(token["data"]);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardPanel()));
          } else {
            errorFeedback = token["message"];
          }
        }));
  }

  void showAppSettings() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              titlePadding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
              contentPadding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text("Zmień ustawienia serwera"),
              content: SizedBox(
                  height: 300,
                  width: 300,
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Text("Wybierz sposób połączenia z serwerem"),
                        if (isLoading)
                          const Center(
                              child:
                                  CircularProgressIndicator(color: mainColor))
                        else
                          Form(
                            key: formKey,
                            child: Column(
                              children: [],
                            ),
                          )
                      ]))),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
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
                      onPressed: () {
                        print("settings");
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Image(
                          width: 200,
                          height: 200,
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Proszę podać adres email";
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  emailInput = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(20),
                                    prefixIcon: Padding(
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
                              SizedBox(
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
                                    prefixIcon: Padding(
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
                              SizedBox(
                                height: 20,
                              ),
                              if (!errorFeedback.isEmpty) ...[
                                Text(
                                  "${errorFeedback}",
                                  style: TextStyle(
                                      color: errorColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.2),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: mainColor,
                                        primary: mainColor,
                                        onSurface: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        // user model
                                        errorFeedback = "";
                                        saveData();
                                        print(
                                            "email: ${emailInput} pass: ${passInput}");
                                      }
                                    },
                                    icon: isLoading
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            padding: EdgeInsets.all(2),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : Icon(
                                            Icons.login,
                                            color: bgSmokedWhite,
                                          ),
                                    label: Text(
                                      "Zaloguj się",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: bgSmokedWhite),
                                    )),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  primary: fontBlack,
                                  onSurface: secondColor,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PasswordResetCode(),
                                    ));
                              },
                              child: Text("Nie pamiętam hasła"))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Nie masz konta?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  primary: fontBlack,
                                  onSurface: secondColor,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/registerUser',
                                );
                              },
                              child: Text("Zarejestruj się"))
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
          actionsPadding: EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text("Czy na pewno chcesz wyjść z\u{00A0}aplikacji? "),
          content: Text("Mamy nadzieję, że zaraz tutaj wrócisz!"),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    onPrimary: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Anuluj",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: deleteBtn,
                    onPrimary: deleteBtn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
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
