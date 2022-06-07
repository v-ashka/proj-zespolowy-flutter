import 'package:flutter/material.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({Key? key}) : super(key: key);

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {

  void authorizeUser() async{
    Map userData = {};
    print("Check user data");
    //Future.delayed(Duration(seconds: 3));
    print("login succesfull/failed");

    userData = {"name": "Andrzej", "surname": "Wąsacz",
      "cars":
        {
          {"name": "polonez caro", "engine": "1.8ohv", "production_data": "1989"},
          {"name": "opel corsa B", "engine": "1.6", "production_data": "1999"}
        },
      "medical_documents":
        {
          {"title": "Poziom cukrzycy we krwi", "content": "Poziom za wysoki", "createdAt": "26-05-2022"}
        }
      };
    Navigator.pushNamed(context, '/dashboard', arguments: {
      "userData": userData
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Login'
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Hasło'
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
                      ElevatedButton(onPressed: (){
                        authorizeUser();
                      },
                          child: Text("Zaloguj się")
                      ),
                    ],
                  )
              )
            )
          ],
        )
      ),
    );
  }
}
