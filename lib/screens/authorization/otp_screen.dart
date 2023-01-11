// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/screens/authorization/set_new_password.dart';
import 'package:organizerPRO/services/auth_service.dart';

class OTPScreen extends StatefulWidget {
  final String? email;
  final String resetId;
  final bool isSMS;
  const OTPScreen(
      {Key? key,
      required this.resetId,
      required this.email,
      required this.isSMS})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isLoading = false;
  bool isSMSLoading = false;
  bool isCodeSent = false;
  String? emailInput = "";
  String? passInput = "";
  String? pin;
  // Error feedback
  String errorFeedback = "";
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void showLoadingDialog(isShowing, context) {
    if (isShowing) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: bgSmokedWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.transparent),
      ),
    );

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
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          "Weryfikacja kodu",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 38,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            !widget.isSMS
                                ? const TextSpan(text: 'Na adres ')
                                : const TextSpan(
                                    text:
                                        'Na numer telefonu powiązany z adresem e-mail '),
                            TextSpan(
                                text: widget.email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondColor)),
                            !widget.isSMS
                                ? const TextSpan(
                                    text:
                                        ' został wysłany sześciocyfrowy kod resetowania hasła. Przejdź do swojej skrzynki pocztowej i\u{00A0}wpisz poniżej otrzymany kod.')
                                : const TextSpan(
                                    text:
                                        ' został wysłany sześciocyfrowy kod resetowania hasła. Przejdź do swojej skrzynki odbiorczej SMS i\u{00A0}wpisz poniżej otrzymany kod.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                      Center(
                          child: Form(
                        key: formKey,
                        child: Pinput(
                            hapticFeedbackType: HapticFeedbackType.heavyImpact,
                            autofocus: true,
                            length: 6,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (pin) => this.pin = pin,
                            forceErrorState: false,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              height: 55,
                              width: 55,
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: secondColor),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                  color: bgSmokedWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.red)),
                            ),
                            validator: (pin) {
                              if (pin == null || pin.length != 6) {
                                return "Wprowadź kod prawidłowo";
                              }
                              return null;
                            }),
                      )),
                      const SizedBox(height: 50),
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: secondColor,
                                  backgroundColor: secondColor,
                                  disabledForegroundColor:Colors.amber.withOpacity(0.38),
                                  disabledBackgroundColor:Colors.amber.withOpacity(0.12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  formKey.currentState!.save();
                                  showLoadingDialog(true, context);
                                  Response? response = await UserApiService()
                                      .verifyCode(widget.resetId, pin!);
                                  if (response?.statusCode == 200) {
                                    storage.write(
                                        key: "resetToken",
                                        value: response!.data);
                                    showLoadingDialog(false, context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                NewPasswordView(
                                                    resetId: widget.resetId)),
                                        ModalRoute.withName("/user_auth"));
                                  }
                                }
                              },
                              child: const Text(
                                "Weryfikuj",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: bgSmokedWhite),
                              )),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Nie otrzymałeś kodu?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  primary: secondColor,
                                  onSurface: secondColor,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                // Navigator.pushReplacementNamed(
                                //   context,
                                //   '/registerUser',
                                // );
                              },
                              child: Text("Wyślij ponownie"))
                        ],
                      )
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
