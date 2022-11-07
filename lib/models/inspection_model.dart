import 'dart:convert';

class InspectionModel {
  InspectionModel(
      {this.idPrzegladu,
      this.czyPozytywny,
      this.uwagi,
      this.dataPrzegladu,
      this.koniecWaznosciPrzegladu,
      this.nazwaStacjiDiagnostycznej,
      this.zarejestrowanyPrzebieg,
      this.numerBadania});

  String? idPrzegladu;
  bool? czyPozytywny;
  String? uwagi;
  String? dataPrzegladu;
  String? koniecWaznosciPrzegladu;
  String? nazwaStacjiDiagnostycznej;
  int? zarejestrowanyPrzebieg;
  String? numerBadania;

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      InspectionModel(
          idPrzegladu: json["idPrzegladu"],
          czyPozytywny: json["czyPozytywny"],
          uwagi: json["uwagi"],
          dataPrzegladu: json["dataPrzegladu"],
          koniecWaznosciPrzegladu: json["koniecWaznosciPrzegladu"],
          nazwaStacjiDiagnostycznej: json["nazwaStacjiDiagnostycznej"],
          zarejestrowanyPrzebieg: json["zarejestrowanyPrzebieg"],
          numerBadania: json["numerBadania"]);

  Map<String, dynamic> toJson() => {
        "czyPozytywny": czyPozytywny,
        "uwagi": uwagi,
        "dataPrzegladu": dataPrzegladu,
        "koniecWaznosciPrzegladu": koniecWaznosciPrzegladu,
        "nazwaStacjiDiagnostycznej": nazwaStacjiDiagnostycznej,
        "zarejestrowanyPrzebieg": zarejestrowanyPrzebieg,
        "numerBadania": numerBadania
      };
}

List<InspectionModel> inspectionListFromJson(String str) =>
    List<InspectionModel>.from(
        json.decode(str).map((x) => InspectionModel.fromJson(x)));
