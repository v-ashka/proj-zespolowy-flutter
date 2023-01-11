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

//Model danych wykorzystywany przy rejestracji użytkownika
class UserRegister {
  UserRegister(
      {required this.imie,
      required this.email,
      required this.haslo,
      required this.numerTelefonu});

  String? imie;
  String? email;
  String? haslo;
  String? numerTelefonu;

  Map<String, dynamic> toJson() => {
        "imie": imie,
        "email": email,
        "haslo": haslo,
        "numerTelefonu": numerTelefonu
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
