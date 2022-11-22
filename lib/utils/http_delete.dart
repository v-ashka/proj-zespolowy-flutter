import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/utils/http_delete.dart';

enum Endpoints {
  carDefault,
  carInsurance,
  carInspection,
  carRepair,
  file,
  receiptDefault
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
      case Endpoints.file:
        return '$SERVER_IP/api/fileUpload/DeleteFile';
      case Endpoints.receiptDefault:
        return '$SERVER_IP/api/receipt/DeleteRecipt';
    }
  }
}

Future deleteRecord(Endpoints endpoint, token, id) async {
  try {
    var url = Uri.parse("${endpoint.text}/$id");
    var response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    });
    print(id);
    print(url);
    print(response.statusCode);
    print(response.reasonPhrase);
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
