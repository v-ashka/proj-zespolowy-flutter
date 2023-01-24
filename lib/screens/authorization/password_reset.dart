// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/screens/authorization/otp_screen.dart';
import 'package:organizerPRO/services/auth_service.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);
  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isEmailLoading = false;
  bool isSMSLoading = false;
  String? emailInput = "";
  String? passInput = "";
  String resetId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          "Resetowanie hasła",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 38,
                          ),
                        ),
                      ),
                      const Text(
                          "Aby zresetować hasło, podaj adres e-mail powiązany z\u{00A0}Twoim kontem. Na podany adres mailowy lub numer telefonu, który został podany przy rejestracji zostanie wysłana wiadomość z\u{00A0}sześciocyfrowym kodem resetowania.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      const SizedBox(height: 80),
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
                                    padding: EdgeInsets.fromLTRB(5, 8, 0, 8),
                                    child: Text("Adres e-mail",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: fontBlack)),
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
                                    hintText: "Podaj adres e-mail",
                                    fillColor: bgSmokedWhite,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                              SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: secondColor,
                                        backgroundColor: secondColor,
                                        disabledForegroundColor:
                                            Colors.amber.withOpacity(0.38),
                                        disabledBackgroundColor:
                                            Colors.amber.withOpacity(0.12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if (isEmailLoading || isSMSLoading) {
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          isEmailLoading = true;
                                        });
                                        formKey.currentState!.save();
                                        Response? response =
                                            await UserApiService()
                                                .resetPassword(emailInput, false);
                                        if (response!.statusCode == 200) {
                                          setState(() {
                                            resetId = response.data;
                                            isEmailLoading = false;
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        OTPScreen(resetId: resetId, email: emailInput,
                                                  isSMS: false,
                                                ),
                                              ),
                                              ModalRoute.withName("/user_auth"));
                                        }
                                      }
                                    },
                                    icon: isEmailLoading
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
                                            Icons.mail_outline,
                                            color: bgSmokedWhite,
                                          ),
                                    label: const Text(
                                      "Wyślij kod w wiadomości e-mail",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: bgSmokedWhite),
                                    )),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 320,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: secondColor,
                                        backgroundColor: secondColor,
                                        disabledForegroundColor:
                                            Colors.amber.withOpacity(0.38),
                                        disabledBackgroundColor:
                                            Colors.amber.withOpacity(0.12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if (isEmailLoading || isSMSLoading) {
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          isSMSLoading = true;
                                        });
                                        formKey.currentState!.save();
                                        Response? response =
                                            await UserApiService()
                                                .resetPassword(emailInput, true);
                                        if (response!.statusCode == 200) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        OTPScreen(
                                                  resetId: response.data,
                                                  email: emailInput,
                                                  isSMS: true,
                                                ),
                                              ),
                                              ModalRoute.withName(
                                                  "/user_auth"));
                                        }
                                      }
                                    },
                                    icon: isSMSLoading
                                        ? Container(
                                            width: 24,
                                            height: 24,
                                            padding: const EdgeInsets.all(2),
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.sms_outlined,
                                            color: bgSmokedWhite,
                                          ),
                                    label: const Text(
                                      "Wyślij kod w wiadomości SMS",
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
