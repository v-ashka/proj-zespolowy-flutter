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
      this.idTypDomu,
      this.typDomu,
      this.liczbaDodanychPomieszczen});

  String? idDomu;
  String? ulicaNrDomu;
  String? kodPocztowy;
  String? miejscowosc;
  String? rokWprowadzenia;
  String? powierzchniaDomu;
  String? powierzchniaDzialki;
  String? liczbaPokoi;
  int? idTypDomu;
  String? typDomu;
  int? liczbaDodanychPomieszczen;

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
        ulicaNrDomu: json["ulicaNrDomu"],
        miejscowosc: json["miejscowosc"],
        rokWprowadzenia: json["rokWprowadzenia"],
        powierzchniaDomu: json["powierzchniaDomu"],
        powierzchniaDzialki: json["powierzchniaDzialki"],
        liczbaPokoi: json["liczbaPokoi"],
        typDomu: json["typDomu"],
        liczbaDodanychPomieszczen: json["liczbaDodanychPomieszczen"]);
}

List<HomeModel> homeListFromJson(String str) =>
    List<HomeModel>.from(
        json.decode(str).map((x) => HomeModel.fromJson(x)));

class HomeListView {
  String? idDomu;
  String? typDomu;
  String? ulicaNrDomu;
  String? miejscowosc;

  HomeListView({
    this.idDomu,
    this.typDomu,
    this.ulicaNrDomu,
    this.miejscowosc,
  });

  factory HomeListView.fromJson(Map<String, dynamic> json) => HomeListView(
    idDomu: json["idDomu"],
    typDomu: json["typDomu"],
    ulicaNrDomu: json["ulicaNrDomu"],
    miejscowosc: json["miejscowosc"],

  );
}

List<HomeListView> homeListViewFromJson(String str) => List<HomeListView>.from(
    json.decode(str).map((x) => HomeListView.fromJson(x)));
