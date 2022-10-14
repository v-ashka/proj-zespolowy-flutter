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

class UserAuthenticationRegister extends StatefulWidget {
  const UserAuthenticationRegister({Key? key}) : super(key: key);
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  State<UserAuthenticationRegister> createState() =>
      _UserAuthenticationRegisterState();
}

class _UserAuthenticationRegisterState
    extends State<UserAuthenticationRegister> {
  // Local flutter storage token
  final storage = new FlutterSecureStorage();

  // Form variables
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isLoading = false;
  bool _passValid = false;

  String? loginInput = "";
  String? nameInput = "";
  String? emailInput = "";
  String? passInput = "";
  String? secondPassInput = "";
  var testPass1 = TextEditingController();
  var testPass2 = TextEditingController();

  // Error feedback
  String errorFeedback = "";
  String passFeedback = "";

  void registerUser() async {
    setState(() => isLoading = true);
    Map<String, dynamic> payload = {};
    UserRegister data = UserRegister(
        login: loginInput,
        name: nameInput,
        email: emailInput,
        pass: passInput,
        secondPass: secondPassInput);
    var registerProcess = await UserApiService().register(data);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = false;
          if (registerProcess != null) {
            Navigator.pushNamed(context, '/user_auth',
                arguments: {"successRegister": true});
          } else {
            errorFeedback = "Podano nieprawidłowe dane!";
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
          decoration: BoxDecoration(
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
                        "Zarejestruj się",
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
                          setState(() {
                            if (testPass1.text != testPass2.text) {
                              passFeedback = "Hasła się nie zgadzają";
                            } else {
                              passFeedback = "";
                            }
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Proszę podać nazwę użytkownika";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                loginInput = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.supervised_user_circle_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Podaj nazwę użytkownika...",
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
                                  return "Proszę podać imię";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                nameInput = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.account_circle_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Podaj swoje imię...",
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
                                  hintText: "Podaj adres email...",
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
                              controller: testPass1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Proszę podać hasło";
                                }
                                return null;
                              },
                              onChanged: (String? value) {
                                passInput = value;
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
                              height: 10,
                            ),
                            TextFormField(
                              controller: testPass2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Proszę podać ponownie hasło";
                                }
                                return null;
                              },
                              onChanged: (String? value) {
                                secondPassInput = value;
                              },
                              onSaved: (String? value) {
                                secondPassInput = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.fingerprint_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Wprowadź ponownie hasło...",
                                  fillColor: bgSmokedWhite,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            if (!passFeedback.isEmpty) ...[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${passFeedback}",
                                style: TextStyle(
                                    color: errorColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.2),
                              ),
                            ],
                            SizedBox(
                              height: 10,
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
                            ],
                            SizedBox(
                              width: 200,
                              height: 60,
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
                                      registerUser();
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
                                    "Zarejestruj się",
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
                          "Masz już konto?",
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
                                '/user_auth',
                              );
                            },
                            child: Text("Zaloguj się"))
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
