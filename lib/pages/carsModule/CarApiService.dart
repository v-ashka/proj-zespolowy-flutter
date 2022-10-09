import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'Car.dart';
import 'package:projzespoloey/constants.dart';

class CarApiService {
  final today = DateTime.now();

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<List<CarModel>?> getCars(token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        getToken(token);

        // var id = 2;
        List<CarModel> _model = carModelFromJson(response.body);
        _model.map((e) => e.test = ["12"]);
        return await _model;
      }

      print(response.statusCode);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getCar(token, id) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/GetCar/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List?> getInsurance(token, id) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/insurance/GetInsuranceList/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteInsurance(token, id) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/insurance/GetInsuranceList/${id}");
      var response = await http.delete(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });
      print(response);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List?> getService(token, id) async {
    try {
      var url =
          Uri.parse("${SERVER_IP}/api/inspection/GetInspectionsList/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
