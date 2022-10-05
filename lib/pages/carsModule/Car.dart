import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String userToken = "";

List<CarModel> carModelFromJson(String str) =>
    List<CarModel>.from(json.decode(str).map((x) => CarModel.fromJson(x)));

String carModelToJson(List<CarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

void getToken(String token) {
  userToken = token;
}

class CarModel {
  CarModel({
    required this.id,
    required this.engineCapacity,
    required this.prodDate,
    required this.vin,
    required this.purchaseDate,
    required this.regNr,
    required this.imgId,
    required this.model,
    required this.brand,
    required this.test,
    // required this.insurance,
    // required this.service
  });

  String id;
  String engineCapacity;
  String prodDate;
  String vin;
  String purchaseDate;
  String regNr;
  String imgId;
  String model;
  String brand;
  String test;
  // Insurance insurance;
  // Service service;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json["idPubliczne"],
        engineCapacity: json["pojemnoscSilnika"],
        prodDate: json["rokProdukcji"],
        vin: json["numerVin"],
        purchaseDate: json["dataZakupu"],
        regNr: json["numerRejestracyjny"],
        imgId: json["idZdjecia"],
        model: json["model"],
        brand: json["marka"],
        test: "test",
        // insurance: Insurance.fetchData(id, userToken),
        // insurance: Insurance.fromJson(json["insurance"]),
        // insurance: insurance.dataLoaded,
        // service: Service.fromJson(json["service"])
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "engineCapacity": engineCapacity,
        "prodDate": prodDate,
        "vin": vin,
        "purchaseDate": purchaseDate,
        "regNr": regNr,
        "imgId": imgId,
        "model": model,
        "brand": brand,
        "test": "duppa",
        // "insurance": Insurance.fetchData(id, userToken),
        // "service": service.toJson(),
      };
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

  Future<void> fetchData(id, token) async {
    try {} catch (e) {
      print("error $e");
    }
  }

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
  Service(
      {required this.id,
      required this.isPositive,
      required this.additionalNotes,
      required this.serviceDate,
      required this.nextServiceDate,
      required this.regNr});

  String id;
  bool isPositive;
  String additionalNotes;
  String serviceDate;
  String nextServiceDate;
  String regNr;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
      id: json["id"],
      isPositive: json["isPositive"],
      additionalNotes: json["additionalNotes"],
      serviceDate: json["serviceDate"],
      nextServiceDate: json["nextServiceDate"],
      regNr: json["regNr"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "isPositive": isPositive,
        "additionalNotes": additionalNotes,
        "serviceDate": serviceDate,
        "nextServiceDate": nextServiceDate,
        "regNr": regNr
      };
}
