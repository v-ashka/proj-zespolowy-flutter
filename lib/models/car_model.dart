import 'dart:convert';
import 'package:flutter/material.dart';

List<CarModel> carModelFromJson(String str) =>
    List<CarModel>.from(json.decode(str).map((x) => CarModel.fromJson(x)));

List<CarListView> carListViewFromJson(String str) => List<CarListView>.from(
    json.decode(str).map((x) => CarListView.fromJson(x)));

String carModelToJson(List<CarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarModel {
  CarModel(
      {this.idSamochodu,
      this.pojemnoscSilnika,
      this.rokProdukcji,
      this.numerVin,
      this.dataZakupu,
      this.numerRejestracyjny,
      this.przebieg,
      this.model,
      this.marka,
      this.rodzajSkrzyniBiegow,
      this.rodzajNapedu,
      this.rodzajPaliwa,
      this.moc,
      this.koniecOC,
      this.koniecAC,
      this.koniecPrzegladu,
      this.zarchiwizowanePolisy,
      this.zarchiwizowanePrzeglady,
      this.ostatniaNaprawa});

  String? idSamochodu;
  int? pojemnoscSilnika;
  int? rokProdukcji;
  String? numerVin;
  String? dataZakupu;
  String? numerRejestracyjny;
  int? przebieg;
  String? model;
  String? marka;
  String? rodzajSkrzyniBiegow;
  String? rodzajNapedu;
  String? rodzajPaliwa;
  int? moc;
  int? koniecOC;
  int? koniecAC;
  int? koniecPrzegladu;
  int? zarchiwizowanePolisy;
  int? zarchiwizowanePrzeglady;
  int? ostatniaNaprawa;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
      idSamochodu: json["idSamochodu"],
      pojemnoscSilnika: json["pojemnoscSilnika"],
      rokProdukcji: json["rokProdukcji"],
      numerVin: json["numerVin"],
      dataZakupu: json["dataZakupu"],
      numerRejestracyjny: json["numerRejestracyjny"],
      model: json["model"],
      marka: json["marka"],
      koniecOC: json["koniecOC"],
      koniecAC: json["koniecAC"],
      koniecPrzegladu: json["koniecPrzegladu"],
      zarchiwizowanePolisy: json["zarchiwizowanePolisy"],
      zarchiwizowanePrzeglady: json["zarchiwizowanePrzeglady"],
      przebieg: json["przebieg"],
      rodzajSkrzyniBiegow: json["rodzajSkrzyniBiegow"],
      rodzajNapedu: json["rodzajNapedu"],
      rodzajPaliwa: json["rodzajPaliwa"],
      moc: json["moc"],
      ostatniaNaprawa: json["ostatniaNaprawa"]);

  Map<String, dynamic> toJson() => {
        "idSamochodu": idSamochodu,
        "pojemnoscSilnika": pojemnoscSilnika,
        "rokProdukcji": rokProdukcji,
        "numerVin": numerVin,
        "dataZakupu": DateTime.parse(dataZakupu!),
        "numerRejestracyjny": numerRejestracyjny,
        "model": model,
        "marka": marka,
        "koniecOC": koniecOC,
        "koniecAC": koniecAC,
        "koniecPrzegladu": koniecPrzegladu,
        "zarchiwizowanePolisy": zarchiwizowanePolisy,
        "zarchiwizowanePrzeglady": zarchiwizowanePrzeglady,
        "przebieg": przebieg,
        "rodzajSkrzyniBiegow": rodzajSkrzyniBiegow,
        "rodzajNapedu": rodzajNapedu,
        "rodzajPaliwa": rodzajPaliwa,
        "moc": moc,
        "ostatniaNaprawa": ostatniaNaprawa
      };
}

// extension CarModelExtension on CarModel{
//   CarModelForm get toFormModel => CarModelForm(
//       PojemnoscSilnika: pojemnoscSilnika, RokProdukcji: rokProdukcji,
//       NumerVin: numerVin,
//       DataZakupu: dataZakupu,
//       NumerRejestracyjny: numerRejestracyjny,
//       Moc: moc,
//       Przebieg: przebieg,
//       idRodzajuSkrzyniBiegow: rodzajSkrzyniBiegow;
//   idRodzajuNapedu;
//   idRodzajuPaliwa;
//   );
// }

class CarListView {
  CarListView(
      {required this.idSamochodu,
      required this.model,
      required this.marka,
      required this.koniecOC,
      required this.koniecPrzegladu});

  String idSamochodu;
  String model;
  String marka;
  int? koniecOC;
  int? koniecPrzegladu;

  factory CarListView.fromJson(Map<String, dynamic> json) => CarListView(
      idSamochodu: json["idSamochodu"],
      model: json["model"],
      marka: json["marka"],
      koniecOC: json["koniecOC"],
      koniecPrzegladu: json["koniecPrzegladu"]);
}

class CarModelForm {
  CarModelForm(
      {this.pojemnoscSilnika,
      this.rokProdukcji,
      this.numerVin,
      this.dataZakupu,
      this.numerRejestracyjny,
      this.idModelu,
      this.moc,
      this.przebieg,
      this.idRodzajuNapedu,
      this.idRodzajuPaliwa,
      this.idRodzajuSkrzyniBiegow});

  String? pojemnoscSilnika;
  String? rokProdukcji;
  String? numerVin;
  String? dataZakupu;
  String? numerRejestracyjny;
  int? idModelu;
  String? moc;
  String? przebieg;
  int? idRodzajuSkrzyniBiegow;
  int? idRodzajuNapedu;
  int? idRodzajuPaliwa;

  Map<String, dynamic> toJson() => {
        "pojemnoscSilnika": pojemnoscSilnika,
        "rokProdukcji": rokProdukcji,
        "numerVin": numerVin,
        "dataZakupu": dataZakupu,
        "numerRejestracyjny": numerRejestracyjny,
        "moc": moc,
        "przebieg": przebieg,
        "idRodzajuSkrzyniBiegow": idRodzajuSkrzyniBiegow,
        "idRodzajuNapedu": idRodzajuNapedu,
        "idRodzajuPaliwa": idRodzajuPaliwa,
        "idModelu": idModelu,
      };

  factory CarModelForm.fromJson(Map<String, dynamic> json) {
    return CarModelForm(
  pojemnoscSilnika: json["pojemnoscSilnika"],
  rokProdukcji: json["rokProdukcji"],
  numerVin: json["numerVin"],
  dataZakupu: json["dataZakupu"],
  numerRejestracyjny: json["numerRejestracyjny"],
  moc: json["moc"],
  przebieg: json["przebieg"],
  idRodzajuSkrzyniBiegow: json["idRodzajuSkrzyniBiegow"],
  idRodzajuNapedu: json["idRodzajuNapedu"],
  idRodzajuPaliwa: json["idRodzajuNapedu"],
  idModelu: json["idModelu"]);
  }

}