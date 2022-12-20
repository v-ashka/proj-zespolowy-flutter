import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';

import '../components/password_requirement.dart';

class UserAuthenticationRegister extends StatefulWidget {
  const UserAuthenticationRegister({Key? key}) : super(key: key);
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

  String? nameInput = "";
  String? emailInput = "";
  String passInput = "";
  String? secondPassInput = "";
  String? phoneNumber;
  var testPass1 = TextEditingController();
  var testPass2 = TextEditingController();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PL';
  String errorFeedback = "";
  String passFeedback = "";

  //Funkcja odpowiadająca za rejestrację użytkownika
  void registerUser() async {
    setState(() => isLoading = true);
    UserRegister data = UserRegister(
        imie: nameInput,
        email: emailInput,
        haslo: passInput,
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

  //Funkcja walidująca hasło użytkownika pod kątem wymagań bezpiecznego hasła
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

  //Funkcja walidująca adres e-mail podany przez użytkownika
  String? emailValidation(String? value) {
    bool validation = RegExp('[a-z0-9!#\$%&\'*+/=?^_`{|}~-]+(?:.[a-z0-9!#\$%&\'*+/=?'
        '^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?')
        .hasMatch(value!);
    if (value.isEmpty) {
      return "Proszę podać adres e-mail!";
    } else if (!validation) {
      return "Proszę podać prawidłowy adres e-mail!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: myAppBar(context, HeaderTitleType.createAccount),
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
                const SizedBox(
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Text("Imię",
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
                                  return "Proszę podać imię!";
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                nameInput = value;
                              },
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Text("Adres e-mail",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                )
                              ],
                            ),
                            TextFormField(
                              validator: emailValidation,
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
                                  hintText: "Adres e-mail",
                                  fillColor: bgSmokedWhite,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Text("Numer telefonu",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                )
                              ],
                            ),
                            TextFormField(
                              validator: emailValidation,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Text("Hasło",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                )
                              ],
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
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      isObscure = !isObscure;
                                    }),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 1, 15, 0),
                                    icon: Icon(
                                      isObscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
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
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
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
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      isSecondObscure = !isSecondObscure;
                                    }),
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 1, 15, 0),
                                    icon: Icon(
                                      isSecondObscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: 200,
                              height: 60,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: mainColor,
                                      backgroundColor: mainColor,
                                      disabledForegroundColor:
                                          Colors.amber.withOpacity(0.38),
                                      disabledBackgroundColor:
                                          Colors.amber.withOpacity(0.12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      )),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      errorFeedback = "";
                                      registerUser();
                                    }
                                  },
                                  icon: isLoading
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
                                          Icons.login,
                                          color: bgSmokedWhite,
                                        ),
                                  label: const Text(
                                    "Zarejestruj się",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: bgSmokedWhite),
                                  )),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Masz już konto?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: fontBlack,
                                disabledForegroundColor:
                                    secondColor.withOpacity(0.38),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/user_auth',
                              );
                            },
                            child: const Text("Zaloguj się"))
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
