import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';

List<CarModel> carModelFromJson(String str) =>
    List<CarModel>.from(json.decode(str).map((x) => CarModel.fromJson(x)));

List<CarListView> carListViewFromJson(String str) => List<CarListView>.from(
    json.decode(str).map((x) => CarListView.fromJson(x)));

String carModelToJson(List<CarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Insurance> insuranceModelFromJson(String str) =>
    List<Insurance>.from(json.decode(str).map((x) => Insurance.fromJson(x)));

class CarModel {
  CarModel(
      {required this.id,
      required this.engineCapacity,
      required this.prodDate,
      required this.vin,
      required this.purchaseDate,
      required this.regNr,
      required this.model,
      required this.brand,
      required this.koniecOC

      // required this.service
      });

  String id;
  int engineCapacity;
  int prodDate;
  String vin;
  String purchaseDate;
  String regNr;
  String model;
  String brand;
  int koniecOC;

  // Insurance insurance;
  // Service service;
  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
      id: json["idSamochodu"],
      engineCapacity: json["pojemnoscSilnika"],
      prodDate: json["rokProdukcji"],
      vin: json["numerVin"],
      purchaseDate: json["dataZakupu"],
      regNr: json["numerRejestracyjny"],
      model: json["model"],
      brand: json["marka"],
      koniecOC: json["koniecOC"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "engineCapacity": engineCapacity,
        "prodDate": prodDate,
        "vin": vin,
        "purchaseDate": DateTime.parse(purchaseDate),
        "regNr": regNr,
        "model": model,
        "brand": brand,
      };
}

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

class Insurance {
  bool dataLoaded = false;
  Insurance(
      {required this.id,
      required this.insuranceName,
      required this.insurancePolicyNr,
      required this.startPolicyDate,
      required this.endPolicyDate,
      required this.policyPrice,
      required this.insuranceType});

  String id;
  String insuranceName;
  String insurancePolicyNr;
  String startPolicyDate;
  String endPolicyDate;
  double policyPrice;
  int insuranceType;

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
        id: json["id"],
        insuranceName: json["insuranceName"],
        insurancePolicyNr: json["insurancePolicyNr"],
        startPolicyDate: json["startPolicyDate"],
        endPolicyDate: json["endPolicyDate"],
        policyPrice: json["policyPrice"],
        insuranceType: json["insuranceType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "insuranceName": insuranceName,
        "insurancePolicyNr": insurancePolicyNr,
        "startPolicyDate": startPolicyDate,
        "endPolicyDate": endPolicyDate,
        "policyPrice": policyPrice,
        "insuranceType": insuranceType
      };
}

class Service {
  Service({
    required this.idPrzegladu,
    required this.czyPozytywny,
    required this.uwagi,
    required this.dataPrzegladu,
    required this.koniecWaznosciPrzegladu,
  });

  String idPrzegladu;
  bool czyPozytywny;
  String uwagi;
  String dataPrzegladu;
  String koniecWaznosciPrzegladu;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        idPrzegladu: json["idPrzegladu"],
        czyPozytywny: json["czyPozytywny"],
        uwagi: json["uwagi"],
        dataPrzegladu: json["dataPrzegladu"],
        koniecWaznosciPrzegladu: json["koniecWaznosciPrzegladu"],
      );

  Map<String, dynamic> toJson() => {
        "czyPozytywny": czyPozytywny,
        "uwagi": uwagi,
        "dataPrzegladu": dataPrzegladu,
        "koniecWaznosciPrzegladu": koniecWaznosciPrzegladu,
      };

  factory Service.getData(data) {
    return Service(
        idPrzegladu: data.first["idPrzegladu"],
        czyPozytywny: data.first["czyPozytywny"],
        uwagi: data.first["uwagi"],
        dataPrzegladu: data.first["dataPrzegladu"],
        koniecWaznosciPrzegladu: data.first["koniecWaznosciPrzegladu"]);
  }
}

class CarModelForm {
  CarModelForm({
    this.PojemnoscSilnika,
    this.RokProdukcji,
    this.NumerVin,
    this.DataZakupu,
    this.NumerRejestracyjny,
    this.IdModelu,
  });
  int? PojemnoscSilnika;
  int? RokProdukcji;
  String? NumerVin;
  String? DataZakupu;
  String? NumerRejestracyjny;
  int? IdModelu;

  Map<String, dynamic> toJson() => {
        "pojemnoscSilnika": PojemnoscSilnika,
        "rokProdukcji": RokProdukcji,
        "numerVin": NumerVin,
        "dataZakupu": DataZakupu,
        "numerRejestracyjny": NumerRejestracyjny,
        "idModelu": IdModelu,
      };
}

class ServiceFormModel {
  String? DataPrzegladu;
  String? DataNastepnegoPrzegladu;
  String? Uwagi;
  bool? CzyPozytywny;

  ServiceFormModel(
      {this.DataPrzegladu,
      this.DataNastepnegoPrzegladu,
      this.Uwagi,
      this.CzyPozytywny});

  Map<String, dynamic> toJson() => {
        "czyPozytywny": CzyPozytywny,
        "uwagi": Uwagi,
        "dataPrzegladu": DataPrzegladu,
        "dataNastepnegoPrzegladu": "2024-01-01",
      };

  factory ServiceFormModel.fromJson(Map<String, dynamic> json) =>
      ServiceFormModel(
        CzyPozytywny: json["czyPozytywny"],
        Uwagi: json["uwagi"],
        DataPrzegladu: json["dataPrzegladu"],
        DataNastepnegoPrzegladu: json["dataNastepnegoPrzegladu"],
      );
}
