import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';

enum Endpoints {
  carDefault,
  carInsurance,
  carInspection,
  carRepair,
}

extension EndpointsExtension on Endpoints {
  String get text {
    switch (this) {
      case Endpoints.carDefault:
        return '$SERVER_IP/api/car/DeleteCar';
      case Endpoints.carInsurance:
        return '$SERVER_IP/api/insurance/DeleteInsurance';
      case Endpoints.carInspection:
        return '$SERVER_IP/api/inspection/DeleteInspection';
      case Endpoints.carRepair:
        return '$SERVER_IP/api/repair/DeleteRepair';
    }
  }
}

Future deleteRecord(endpoint, token, id) async {
  try {
    var url = Uri.parse("$endpoint/$id");
    var response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    });
    if (response.statusCode == 200 || response.statusCode == 202) {
      print("passed");
      return true;
    }
    ;
    return false;
  } catch (e) {
    log(e.toString());
    return false;
  }
}
