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
