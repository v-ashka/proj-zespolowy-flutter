import 'package:flutter/material.dart';

class UserLogin {
  UserLogin({this.email, this.pass});
  String? email;
  String? pass;

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        email: json["email"],
        pass: json["haslo"],
      );

  Map<String, dynamic> toJson() => {"email": email, "haslo": pass};
}

class UserRegister {
  UserRegister(
      {required this.name,
      required this.email,
      required this.pass,
      required this.secondPass});
  String? name;
  String? email;
  String? pass;
  String? secondPass;

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        name: json["imie"],
        email: json["email"],
        pass: json["haslo"],
        secondPass: json["potwierdzenieHasla"],
      );

  Map<String, dynamic> toJson() => {
        "imie": name,
        "email": email,
        "haslo": pass,
        "potwierdzenieHasla": secondPass
      };
}

class ChangeUserPass {
  String? oldPass;
  String? newPass;
  String? email;

  ChangeUserPass({
    this.oldPass,
    this.newPass,
    this.email,
  });
}
