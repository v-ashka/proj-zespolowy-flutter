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
  final storage = new FlutterSecureStorage();
  // Form variables
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
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
            readJson();
            payload = Jwt.parseJwt(token["data"]);
            Navigator.pushNamed(context, '/dashboard', arguments: {
              "userData": _userData,
              "token": token["data"],
              "tokenData": payload
            });
          } else {
            errorFeedback = token["message"];
          }
        }));
  }

  // temp data for testing purposes
  Map _userData = {};
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/temp.json');
    final data = await json.decode(response);
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                SizedBox(
                  height: 25,
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                      child: Text(
                        "Logowanie",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: fontBlack,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Form(
                        key: formKey,
                        onChanged: () {
                          final formValidation =
                              formKey.currentState!.validate();
                          if (isValid != formValidation) {
                            setState(() {
                              isValid = formValidation;
                            });
                          }
                        },
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
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
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
                                        borderRadius: BorderRadius.circular(25),
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
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nie masz konta?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                primary: fontBlack,
                                onSurface: secondColor,
                                textStyle: TextStyle(
                                  fontSize: 16,
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
    );
  }
}
