import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';

class OTPScreen extends StatefulWidget {
  final String? email;
  final String resetId;
  const OTPScreen({Key? key, required this.resetId, this.email}) : super(key: key);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // Local flutter storage token
  // final storage = new FlutterSecureStorage();
  // Form variables
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
//          barrierDismissible: false,
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
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute<void>(
      //       builder: (BuildContext context) => const CarList(),
      //     ),
      //     ModalRoute.withName("/dashboard"));
    }
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: bgSmokedWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.transparent),
      ),
    );

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
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Na podany adres e-mail '),
                            TextSpan(
                                text: 'seba.wiktor@gmail.com ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondColor)),
                            TextSpan(
                                text:
                                    'został wysłany sześciocyfrowy kod resetowania hasła. Przejdź do swojej skrzynki pocztowej i\u{00A0}poniżej wpisz otrzymany kod.'),
                          ],
                        ),
                      ),
                      SizedBox(height: 80),
                      Center(
                          child: Form(
                        key: formKey,
                        child: Pinput(
                            hapticFeedbackType: HapticFeedbackType.heavyImpact,
                            autofocus: true,
                            length: 6,
                            inputFormatters: <TextInputFormatter>[
                              // for below version 2 use this
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                border: Border.all(color: Colors.red)
                              ),
                            ),
                            validator: (pin) {
                              if (pin == null || pin.length != 6)
                              {
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
                                  onPrimary: secondColor,
                                  primary: secondColor,
                                  onSurface: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                              onPressed: () async {
                                // if (isLoading) {
                                //   return;
                                // }
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  formKey.currentState!.save();
                                  var code = int.parse(pin!);
                                  showLoadingDialog(true, context);
                                  Response? response = await UserApiService().verifyCode(widget.resetId, code);
                                  if(response?.statusCode == 200)
                                    {
                                      print(response!.data);
                                      storage.write(key: "token", value: response.data);
                                      showLoadingDialog(false, context);
                                      print("WSZYSTKO GITARA");
                                    }else{
                                    var reg = RegExp(r'(?<=:)(.*)(?=\r\n)');
                                    var error = reg.firstMatch(response!.data);
                                    String? info = "";
                                    if (error != null) { info = (error.group(0));}

                                    var snackBar = SnackBar(
                                      content: Text("Wystąpił błąd: Kod stracił ważność"),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          Text(
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
