import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/main.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/pages/otp_screen.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';

class PasswordResetCode extends StatefulWidget {
  const PasswordResetCode({Key? key}) : super(key: key);
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  State<PasswordResetCode> createState() => _PasswordResetCodeState();
}

class _PasswordResetCodeState extends State<PasswordResetCode> {
  // Local flutter storage token
  // final storage = new FlutterSecureStorage();
  // Form variables
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isEmailLoading = false;
  bool isSMSLoading = false;
  bool isCodeSent = false;
  String? emailInput = "";
  String? passInput = "";
  String resetId = "";

  // Error feedback
  String errorFeedback = "";

  // void saveData() async {
  //   setState(() => isLoading = true);
  //   Map<String, dynamic> payload = {};
  //   UserLogin data = UserLogin(email: emailInput, pass: passInput);
  //   var token = await UserApiService().login(data);
  //   Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
  //         print("token is:");
  //         print(token);
  //         isLoading = false;
  //
  //         if (token["data"] != null) {
  //           readJson();
  //           var payload = Jwt.parseJwt(token["data"]);
  //           storage.write(
  //               key: "userName",
  //               value: payload[
  //                   "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]);
  //           // payload = Jwt.parseJwt(token["data"]);
  //           Navigator.pushNamed(context, '/dashboard', arguments: {
  //             "userData": _userData,
  //             // "token": token["data"],
  //             // "tokenData": payload
  //           });
  //         } else {
  //           errorFeedback = token["message"];
  //         }
  //       }));
  // }

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
      appBar: myAppBar(context, HeaderTitleType.passwordResetCode),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: ListView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          "Resetowanie hasła",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 38,
                          ),
                        ),
                      ),
                      Text(
                          "Aby zresetować hasło, podaj adres e-mail powiązany z\u{00A0}Twoim kontem. Na podany adres mailowy lub numer telefonu, który został podany przy rejestracji zostanie wysłana wiadomość z\u{00A0}sześciocyfrowym kodem resetowania.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      SizedBox(height: 80),

                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 8, 0, 8),
                                    child: Text("Adres e-mail",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: fontBlack)),
                                  )
                                ],
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Proszę podać adres e-mail!";
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
                                    hintText: "Podaj adres e-mail",
                                    fillColor: bgSmokedWhite,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              if (!errorFeedback.isEmpty) ...[
                                Text(
                                  "${errorFeedback}",
                                  style: TextStyle(
                                      color: errorColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.2),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                              const SizedBox(height: 15),
                              SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: secondColor,
                                        primary: secondColor,
                                        onSurface: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if(isEmailLoading || isSMSLoading){
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          isEmailLoading = true;
                                        });
                                        formKey.currentState!.save();
                                        // user model
                                        errorFeedback = "";
                                        Response response = await UserApiService().resetPassword(emailInput);
                                        if(response.statusCode == 200){
                                          setState(() {
                                            resetId = response.data;
                                            print(resetId);
                                            isEmailLoading = false;
                                            isCodeSent = true;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (BuildContext context) => OTPScreen(resetId: resetId),
                                              ),
                                              ModalRoute.withName("/user_auth"));
                                        }
                                      }
                                    },
                                    icon: isEmailLoading
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
                                            Icons.mail_outline,
                                            color: bgSmokedWhite,
                                          ),
                                    label: Text(
                                      "Wyślij kod w wiadomości e-mail",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: bgSmokedWhite),
                                    )),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton.icon(

                                    style: ElevatedButton.styleFrom(
                                        onPrimary: secondColor,
                                        primary: secondColor,
                                        onSurface: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if(isEmailLoading || isSMSLoading){
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        // user model
                                        errorFeedback = "";
                                        print(
                                            "email: ${emailInput} pass: ${passInput}");
                                      }
                                    },
                                    icon: isSMSLoading
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
                                            Icons.sms_outlined,
                                            color: bgSmokedWhite,
                                          ),
                                    label: Text(
                                      "Wyślij kod w wiadomości SMS",
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
                    ],
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
