class UserLogin {
  UserLogin({required this.email, required this.pass});
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
      {required this.login,
      required this.name,
      required this.email,
      required this.pass,
      required this.secondPass});
  String? login;
  String? name;
  String? email;
  String? pass;
  String? secondPass;

  factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        login: json["nazwaUzytkownika"],
        name: json["imie"],
        email: json["email"],
        pass: json["haslo"],
        secondPass: json["potwierdzenieHasla"],
      );

  Map<String, dynamic> toJson() => {
        "nazwaUzytkownika": login,
        "imie": name,
        "email": email,
        "haslo": pass,
        "potwierdzenieHasla": secondPass
      };
}
