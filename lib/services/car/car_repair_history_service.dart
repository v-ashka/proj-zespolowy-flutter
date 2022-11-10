import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/car_repair_model.dart';

class CarRepairHistoryService {
  
  Future<CarRepairModel?> getRepair(token, id) async {
    CarRepairModel model = CarRepairModel();
    try {
      var url = Uri.parse("$SERVER_IP/api/repair/GetRepair/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        model = CarRepairModel.fromJson(data);
        return model;
      }
      return model;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future addRepair(token, CarRepairModel model, carId) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/repair/AddRepair/$carId");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(model)
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  Future deleteRepair(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/repair/DeleteRepair/$id");
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateRepair(token, data, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/repair/UpdateRepair/$id");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      print(jsonEncode(data));
      return response;
    } catch (e) {
      log(e.toString());
    }
  }
  Future getRepairList(token, carId) async {
    try {
      List<CarRepairModel> model;
      var url = Uri.parse("$SERVER_IP/api/repair/GetRepairList/$carId");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        model = carRepairListFromJson(response.body);
        return model;
      }
      return response;

    } catch (e) {
      log(e.toString());
    }
  }
}
