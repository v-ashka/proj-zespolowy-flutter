import 'dart:convert';

class HomeModel {
  HomeModel(
      {this.idDomu,
      this.ulicaNrDomu,
      this.kodPocztowy,
      this.miejscowosc,
      this.rokWprowadzenia,
      this.powierzchniaDomu,
      this.powierzchniaDzialki,
      this.liczbaPokoi,
      this.idTypDomu});

  String? idDomu;
  String? ulicaNrDomu;
  String? kodPocztowy;
  String? miejscowosc;
  String? rokWprowadzenia;
  String? powierzchniaDomu;
  String? powierzchniaDzialki;
  String? liczbaPokoi;
  int? idTypDomu;

  Map<String, dynamic> toJson() => {
        "ulicaNrDomu": ulicaNrDomu,
        "kodPocztowy": kodPocztowy,
        "miejscowosc": miejscowosc,
        "rokWprowadzenia": rokWprowadzenia,
        "powierzchniaDomu": powierzchniaDomu,
        "powierzchniaDzialki": powierzchniaDzialki,
        "liczbaPokoi": liczbaPokoi,
        "idTypDomu": idTypDomu
      };

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      HomeModel(
        idDomu: json["idDomu"],
        kodPocztowy: json["kodPocztowy"],
        miejscowosc: json["miejscowosc"],
        rokWprowadzenia: json["rokWprowadzenia"],
        powierzchniaDomu: json["powierzchniaDomu"],
        powierzchniaDzialki: json["powierzchniaDzialki"],
        liczbaPokoi: json["liczbaPokoi"],
        idTypDomu: json["idTypDomu"]);
}

List<HomeModel> homeListFromJson(String str) =>
    List<HomeModel>.from(
        json.decode(str).map((x) => HomeModel.fromJson(x)));
