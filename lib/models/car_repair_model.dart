import 'dart:convert';

class CarRepairModel {
  CarRepairModel(
      {this.idNaprawy,
      this.nazwaNaprawy,
       this.dataNaprawy,
       this.kosztNaprawy,
       this.opis,
       this.warsztat,
       this.przebieg,
       this.dataNastepnejWymiany,
       this.liczbaKilometrowDoNastepnejWymiany});

  String? idNaprawy;
  String? nazwaNaprawy;
  String? dataNaprawy;
  double? kosztNaprawy;
  String? opis;
  String? warsztat;
  int? przebieg;
  String? dataNastepnejWymiany;
  int? liczbaKilometrowDoNastepnejWymiany;


  factory CarRepairModel.fromJson(Map<String, dynamic> json) => CarRepairModel(
      idNaprawy: json["idNaprawy"],
      nazwaNaprawy: json["nazwaNaprawy"],
      dataNaprawy: json["dataNaprawy"],
      kosztNaprawy: json["kosztNaprawy"],
      opis: json["opis"],
      warsztat: json["warsztat"],
      przebieg: json["przebieg"],
      dataNastepnejWymiany: json["dataNastepnejWymiany"],
      liczbaKilometrowDoNastepnejWymiany: json["liczbaKilometrowDoNastepnejWymiany"]);

  Map<String, dynamic> toJson() => {
        "idNaprawy": idNaprawy,
        "nazwaNaprawy": nazwaNaprawy,
        "dataNaprawy": dataNaprawy,
        "kosztNaprawy": kosztNaprawy,
        "opis": opis,
        "warsztat": warsztat,
        "przebieg": przebieg,
        "dataNastepnejWymiany": dataNastepnejWymiany,
        "liczbaKilometrowDoNastepnejWymiany": liczbaKilometrowDoNastepnejWymiany
      };
}

List<CarRepairModel> carRepairListFromJson(String str) =>
    List<CarRepairModel>.from(json.decode(str).map((x) => CarRepairModel.fromJson(x)));
