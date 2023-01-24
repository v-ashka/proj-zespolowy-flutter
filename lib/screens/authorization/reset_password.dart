import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:pinput/pinput.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
  String? pin;

  // Error feedback
  String errorFeedback = "";
  final controller = TextEditingController();
  final focusNode = FocusNode();

  void showLoadingDialog(isShowing, context) {
    if (isShowing) {
      showDialog(
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
                          "Wprowadź nowe hasło",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 38,
                          ),
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Na podany adres e-mail '),
                            TextSpan(
                                text: 'seba.wiktor@gmail.com ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondColor)),
                            TextSpan(
                                text:
                                    'został wysłany sześciocyfrowy kod resetowania hasła. Przejdź do swojej skrzynki pocztowej i\u{00A0}poniżej wpisz otrzymany kod.'),
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
                              // for below version 2 use this
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
                                  disabledForegroundColor:
                                      Colors.amber.withOpacity(0.38),
                                  disabledBackgroundColor:
                                      Colors.amber.withOpacity(0.12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  )),
                              onPressed: () async {
                                if (isEmailLoading || isSMSLoading) {
                                  return;
                                }
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
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
                      const SizedBox(height: 30),
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
                                  foregroundColor: secondColor,
                                  disabledForegroundColor:
                                      secondColor.withOpacity(0.38),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                              },
                              child: const Text("Wyślij ponownie"))
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
