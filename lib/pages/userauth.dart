import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projzespoloey/constants.dart';
import 'package:http/http.dart' as http;

class UserAuth extends StatefulWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {
  Map _userData = {};

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data/temp.json');
    final data = await json.decode(response);
    setState(() {
      _userData = data;
    });
    Navigator.pushNamed(context, '/dashboard',
        arguments: {"userData": _userData});
  }



  void authorizeUser() async {
    Map userData = {};
    print("Check user data");
    //Future.delayed(Duration(seconds: 3));
    print("login succesfull/failed");

    userData = {
      "settings": {"carsVisible": "true", "documentsVisible": "false", "receiptVisible": "false", "otherProductsVisible": "false"},
      "name": "Andrzej",
      "surname": "Wąsacz",
      "cars": {
        {"name": "polonez caro", "engine": "1.8ohv", "production_data": "1989"},
        {"name": "opel corsa B", "engine": "1.6", "production_data": "1999"}
      },
      "medical_documents": {
        {
          "title": "Poziom cukrzycy we krwi",
          "content": "Poziom za wysoki",
          "createdAt": "26-05-2022"
        }
      }
    };
    Navigator.pushNamed(context, '/dashboard',
        arguments: {"userData": userData});
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 23),
      primary: mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final VoidCallback? onTap;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(94, 10, 94, 44),
                child: Image(
                  image: const AssetImage('assets/logo.png'),
                  width: 239,
                  height: 288,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 20, 0, 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Logowanie',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                    child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Login',
                        hintStyle:
                            const TextStyle(fontSize: 20, color: Color(0xff7D7D7D)),
                        fillColor: const Color(0xffF5F5F5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Hasło',
                        hintStyle:
                            const TextStyle(fontSize: 20, color: Color(0xff7D7D7D)),
                        fillColor: const Color(0xffF5F5F5),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
                    SizedBox(
                      width: 256,
                      height: 70,
                      child: ElevatedButton(
                          style: style,
                          onPressed: () {
                            readJson();
                          },
                          child: const Text(
                            "Zaloguj się",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          )),
                    ),
                     Padding(
                      padding: EdgeInsets.fromLTRB(15,37,15,22),
                      child: TextButton(
                        onPressed: () {
                          authorizeUser();
                          },
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(color: const Color(0xff272727)),
                            children: <TextSpan>[
                              TextSpan(text: 'Nie masz konta?', style: TextStyle(fontSize: 20)),
                              TextSpan(text: ' Zarejestruj się', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800), ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50,0,50,30),
                      child: const Text("Odzyskaj hasło",
                      style: TextStyle(fontSize: 20, color: Color(0xff8B8B8B), fontWeight: FontWeight.w600)),
                    )
                  ],
                )))
        ],
      ),
          )),
    );
  }
}
