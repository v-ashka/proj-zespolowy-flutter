import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/main.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';

import '../components/password_requirement.dart';

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
  final formKey = GlobalKey<FormState>();
  bool isValid = false;
  bool isObscure = true;
  bool isSecondObscure = true;
  bool isLoading = false;
  bool _passValid = false;

  String? nameInput = "";
  String? emailInput = "";
  String passInput = "";
  String? secondPassInput = "";
  String? phoneNumber;
  var testPass1 = TextEditingController();
  var testPass2 = TextEditingController();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PL';
  // Error feedback
  String errorFeedback = "";
  String passFeedback = "";

  void registerUser() async {
    setState(() => isLoading = true);
    Map<String, dynamic> payload = {};
    UserRegister data = UserRegister(
        name: nameInput,
        email: emailInput,
        pass: passInput,
        secondPass: secondPassInput,
        numerTelefonu: phoneNumber);
    var registerProcess = await UserApiService().register(data);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {
          isLoading = false;
          if (registerProcess["data"] != null) {
            Navigator.pushNamed(context, '/user_auth',
                arguments: {"successRegister": true});
          } else {
            errorFeedback = registerProcess["message"];
          }
        }));
  }

  String? validation(String? value) {
    bool validation =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
            .hasMatch(value!);
    if (value.isEmpty) {
      return "Proszę podać hasło!";
    } else if (!validation) {
      return "Nie spełniono wymagań dotyczących hasła!";
    }
    return null;
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
      appBar: myAppBar(context, HeaderTitleType.createAccount),
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
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Proszę podać imię!";
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
                                  hintText: "Imię",
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
                                  hintText: "Adres e-mail",
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
                                  return "Proszę podać numer telefonu!";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                phoneNumber = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.call_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Numer telefonu",
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
                              controller: testPass1,
                              validator: validation,
                              onChanged: (String? value) {
                                setState(() {
                                  passInput = value!;
                                });
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
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
                                  hintText: "Hasło",
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
                              regExToCheck: passInput
                                  .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
                              requirementText: "Minimum",
                              requirementTextBold: ' 1 znak specjalny (&-@/.)',
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              obscureText: isSecondObscure,
                              controller: testPass2,
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
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
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
                                      Icons.fingerprint_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Powtórz hasło",
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
                              height: 60,
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
