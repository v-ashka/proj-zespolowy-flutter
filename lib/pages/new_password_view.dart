import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/password_requirement.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/_userAuth.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({Key? key}) : super(key: key);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isSecondObscure = true;
  bool isButtonClicked = false;
  bool isCodeSent = false;
  String? emailInput = "";
  String passInput = "";
  String resetId = "";
  String secondPassInput = "";
  String errorFeedback = "";

  String? validation(String? value) {
    bool validation =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
            .hasMatch(value!);
    if (value.isEmpty) {
      return "Proszę utworzyć nowe hasło!";
    } else if (!validation) {
      return "Nie spełniono wymagań dotyczących hasła!";
    }
    return null;
  }

  void showAcceptedDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: SvgPicture.asset("assets/done.svg", width: 80, height: 80),
            content: SizedBox(
                height: 25,
                width: 250,
                child: Center(
                    child: Text("Twoje hasło zostało zmienione",
                        style: TextStyle(fontFamily: 'Lato', fontSize: 18)))),
            actions: [
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: secondColor,
                        onPrimary: secondColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserAuthentication()));
                    },
                    child: Text(
                      "Przejdź do logowania",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          );
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          "Ustaw nowe hasło",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: fontBlack,
                            fontSize: 38,
                          ),
                        ),
                      ),
                      Text(
                          "Wpisz nowe hasło. Musi ono spełniać warunki, które są podane poniżej. Pamiętaj, aby nikomu nie podawać Twojego hasła! ",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                      SizedBox(height: 30),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 8, 0, 8),
                                    child: Text("Nowe hasło",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: fontBlack)),
                                  )
                                ],
                              ),
                              TextFormField(
                                obscureText: isObscure,
                                validator: validation,
                                onChanged: (value) {
                                  setState(() {
                                    passInput = value;
                                  });
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
                                        Icons.lock_outline,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Utwórz nowe hasło",
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
                              PasswordRequirement(
                                  regExToCheck: passInput.length >= 8,
                                  requirementText: "Co najmniej",
                                  requirementTextBold: ' 8 znaków'),
                              PasswordRequirement(
                                regExToCheck:
                                    passInput.contains(RegExp(r'[A-Z]')),
                                requirementText: "Minimum",
                                requirementTextBold: ' 1 duża litera (A-Z)',
                              ),
                              PasswordRequirement(
                                regExToCheck:
                                    passInput.contains(RegExp(r'[a-z]')),
                                requirementText: "Minimum",
                                requirementTextBold: ' 1 mała litera (a-z)',
                              ),
                              PasswordRequirement(
                                regExToCheck:
                                    passInput.contains(RegExp(r'[0-9]')),
                                requirementText: "Minimum",
                                requirementTextBold: ' 1 cyfra (0-9)',
                              ),
                              PasswordRequirement(
                                regExToCheck: passInput.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
                                requirementText: "Minimum",
                                requirementTextBold:
                                    ' 1 znak specjalny (&-@/.)',
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 8, 0, 8),
                                    child: Text("Potwierdź hasło",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: fontBlack)),
                                  )
                                ],
                              ),
                              TextFormField(
                                obscureText: isSecondObscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Proszę potwierdzić hasło!";
                                  }
                                  if (passInput != secondPassInput) {
                                    return "Podane hasła nie są identyczne!";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    secondPassInput = value;
                                  });
                                },
                                cursorColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(20),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() {
                                        isSecondObscure = !isSecondObscure;
                                      }),
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 1, 15, 0),
                                      icon: Icon(
                                        isSecondObscure
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.lock_outline,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Potwierdź hasło",
                                    fillColor: bgSmokedWhite,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                              SizedBox(height: 50),
                              SizedBox(
                                width: 240,
                                height: 50,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: secondColor,
                                        primary: secondColor,
                                        onSurface: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      if (isButtonClicked) {
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        setState(() {
                                          isButtonClicked = true;
                                        });
                                        formKey.currentState!.save();
                                        var resetToken = await storage.read(
                                            key: "resetToken");
                                        Response response =
                                            await UserApiService()
                                                .changePassword(
                                                    passInput, resetToken);
                                        if (response.statusCode == 200) {
                                          showAcceptedDialog(context);
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.published_with_changes_outlined,
                                      color: bgSmokedWhite,
                                    ),
                                    label: Text(
                                      "Zmień hasło",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: bgSmokedWhite),
                                    )),
                              ),
                              SizedBox(height: 20),
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
