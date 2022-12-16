import 'dart:convert';

class HomeRepairModel {
  HomeRepairModel(
      {this.idNaprawy,
      this.nazwaNaprawy,
      this.wykonawcaNaprawy,
      this.kosztNaprawy,
      this.dataNaprawy,
      this.opis});

  String? idNaprawy;
  String? nazwaNaprawy;
  String? wykonawcaNaprawy;
  String? kosztNaprawy;
  String? dataNaprawy;
  String? opis;

  Map<String, dynamic> toJson() => {

        "nazwaNaprawy": nazwaNaprawy,
        "wykonawcaNaprawy": wykonawcaNaprawy,
        "kosztNaprawy": kosztNaprawy,
        "dataNaprawy": dataNaprawy,
        "opis": opis
      };

  factory HomeRepairModel.fromJson(Map<String, dynamic> json) =>
      HomeRepairModel(
        idNaprawy: json["idNaprawy"],
        nazwaNaprawy: json["nazwaNaprawy"],
        wykonawcaNaprawy: json["wykonawcaNaprawy"],
        kosztNaprawy: json["kosztNaprawy"],
        dataNaprawy: json["dataNaprawy"],
        opis: json["opis"],
      );
}

List<HomeRepairModel> homeRepairListFromJson(String str) =>
    List<HomeRepairModel>.from(
        json.decode(str).map((x) => HomeRepairModel.fromJson(x)));
