import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';

String userToken = "";

List<CarModel> carModelFromJson(String str) =>
    List<CarModel>.from(json.decode(str).map((x) => CarModel.fromJson(x)));

String carModelToJson(List<CarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<CarModel2> carModel2FromJson(String str) =>
    List<CarModel2>.from(json.decode(str).map((x) => CarModel2.fromJson(x)));

String carModel2ToJson(List<CarModel2> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<FileList> fileListFromJson(String str) =>
    List<FileList>.from(json.decode(str).map((x) => FileList.fromJson(x)));

String fileListToJson(List<FileList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<InsuranceFormModel> InsuranceFormModelFromJson(String str) =>
    List<InsuranceFormModel>.from(json.decode(str).map((x) => InsuranceFormModel.fromJson(x)));

void getToken(String token) {
  userToken = token;
}

List<Insurance> insuranceModelFromJson(String str) =>
    List<Insurance>.from(json.decode(str).map((x) => Insurance.fromJson(x)));

class CarModel {
  Future<void> getInsurance(token, id) async {
    id = this.id;
    try {
      var url = Uri.parse("${SERVER_IP}//api/insurance/GetInsurance/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });
      data = jsonDecode(response.body);
    } catch (e) {
      print("error $e");
    }
  }

  List data = [];
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
      koniecOC: json["koniecOC"]

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
        "purchaseDate": DateTime.parse(purchaseDate),
        "regNr": regNr,
        "model": model,
        "brand": brand,
        // "insurance": insurance.toJson(),
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

  // factory Insurance.fetchData(id, token) async {
  //   try {
  //     var url = Uri.parse("https://${SERVER_IP}/api/car/GetList");
  //     var response = await http.get(url, headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': "Bearer ${token}",
  //     });

  //     if (response.statusCode == 200) {
  //       List<Insurance> _model = insuranceModelFromJson(response.body);
  //       print(_model);
  //       return _model;
  //     }
  //   } catch (e) {
  //     print("error $e");
  //   }
  // }

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

class CarModel2 {
  Future<void> getInsurance(token, id) async {
    id = this.id;
    try {
      var url = Uri.parse("${SERVER_IP}//api/insurance/GetInsurance/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });
      data = jsonDecode(response.body);
    } catch (e) {
      print("error $e");
    }
  }

  List data = [];
  CarModel2({
    required this.id,
    required this.engineCapacity,
    required this.prodDate,
    required this.vin,
    required this.purchaseDate,
    required this.regNr,
    required this.imgId,
    required this.model,
    required this.brand,
    required this.insurance,
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
  // List test;
  Insurance insurance;
  // Service service;
  factory CarModel2.fromJson(Map<String, dynamic> json) => CarModel2(
        id: json["idPubliczne"],
        engineCapacity: json["pojemnoscSilnika"],
        prodDate: json["rokProdukcji"],
        vin: json["numerVin"],
        purchaseDate: json["dataZakupu"],
        regNr: json["numerRejestracyjny"],
        imgId: json["idZdjecia"],
        model: json["model"],
        brand: json["marka"],
        insurance: Insurance.fromJson(json["insurance"]),
        // insurance: Insurance.fetchData(id, userToken),

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
        // "test": [],
        "insurance": insurance.toJson(),
        // "service": service.toJson(),
      };
}

class FileList {
  FileList({
    required this.idPliku,
    required this.nazwaPlikuUzytkownika,
    required this.rozszerzenie,
    required this.wielkosc
  });

  String idPliku;
  String nazwaPlikuUzytkownika;
  String rozszerzenie;
  int wielkosc;

  factory FileList.fromJson(Map<String, dynamic> json) => FileList(
        idPliku: json["idPliku"],
        nazwaPlikuUzytkownika: json["nazwaPlikuUzytkownika"],
        rozszerzenie: json["rozszerzenie"],
        wielkosc: json["wielkosc"]
  );

  Map<String, dynamic> toJson() => {
        "idPliku": idPliku,
        "nazwaPlikuUzytkownika": nazwaPlikuUzytkownika,
        "rozszerzenie": rozszerzenie,
        "wielkosc": wielkosc
      };
}

class CarModelForm {
  CarModelForm(
      {
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

class InsuranceFormModel {
  InsuranceFormModel(
      {
        this.Ubezpieczyciel,
        this.NrPolisy,
        this.DataZakupu,
        this.DataKonca,
        this.KosztPolisy,
        this.IdRodzajuUbezpieczenia
      });

  String? Ubezpieczyciel;
  String? NrPolisy;
  String? DataZakupu;
  String? DataKonca;
  int? IdRodzajuUbezpieczenia;
  double? KosztPolisy;

  Map<String, dynamic> toJson() => {
    "ubezpieczyciel": Ubezpieczyciel,
    "nrPolisy": NrPolisy,
    "dataZakupu": DataZakupu,
    "dataKonca": DataKonca,
    "kosztPolisy": KosztPolisy,
    "idRodzajuUbezpieczenia": IdRodzajuUbezpieczenia,
  };

  factory InsuranceFormModel.fromJson(Map<String, dynamic> json) => InsuranceFormModel(
      Ubezpieczyciel: json["ubezpieczyciel"],
      NrPolisy: json["nrPolisy"],
      DataZakupu: json["dataZakupu"],
      DataKonca: json["dataKonca"],
      KosztPolisy: json["kosztPolisy"],
      IdRodzajuUbezpieczenia: json["idRodzajuUbezpieczenia"]);
}

class InsuranceModel {
  InsuranceModel(
      {
        this.IdUbezpieczenia,
        this.Ubezpieczyciel,
        this.NrPolisy,
        this.DataZakupu,
        this.DataKonca,
        this.KosztPolisy,
        this.IdRodzajuUbezpieczenia
      });

  String? IdUbezpieczenia;
  String? Ubezpieczyciel;
  String? NrPolisy;
  String? DataZakupu;
  String? DataKonca;
  int? IdRodzajuUbezpieczenia;
  double? KosztPolisy;

  Map<String, dynamic> toJson() => {
    "idUbezpieczenia": IdUbezpieczenia,
    "ubezpieczyciel": Ubezpieczyciel,
    "nrPolisy": NrPolisy,
    "dataZakupu": DataZakupu,
    "dataKonca": DataKonca,
    "kosztPolisy": KosztPolisy,
    "idRodzajuUbezpieczenia": IdRodzajuUbezpieczenia,
  };

  factory InsuranceModel.fromJson(Map<String, dynamic> json) => InsuranceModel(
      IdUbezpieczenia: json["idUbezpieczenia"],
      Ubezpieczyciel: json["ubezpieczyciel"],
      NrPolisy: json["nrPolisy"],
      DataZakupu: json["dataZakupu"],
      DataKonca: json["dataKonca"],
      KosztPolisy: json["kosztPolisy"],
      IdRodzajuUbezpieczenia: json["idRodzajuUbezpieczenia"]);
}
