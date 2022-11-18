import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Car.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/file_model.dart';
import 'package:projzespoloey/models/insurace_model.dart';

class CarApiService {
  final today = DateTime.now();

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<List<CarListView>> getCars(token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });
      if (response.statusCode == 200) {
        List<CarListView> list = carListViewFromJson(response.body);
        return list;
      } else {
        return [];
      }
      print(response.statusCode);
    } catch (e) {
      log(e.toString());
    }
    return [];
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

  Future<CarModelForm> getCarFormData(token, id) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/GetCarForm/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });
      if (response.statusCode == 200) {
        log(response.body.toString());
        Map<String, dynamic> data = jsonDecode(response.body);
        CarModelForm model = CarModelForm.fromJson(data);
        return model;
      } else {
        return CarModelForm();
      }
    } catch (e) {
      log(e.toString());
    }
    return CarModelForm();
  }

  Future<CarModel?> getCarTest(token, id) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/GetCar/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      log(id.toString());
      if (response.statusCode == 200) {
        var car = jsonDecode(response.body);
        return CarModel.fromJson(car);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future getModeleMarki(token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/MarkiModele");
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

  Future getFuelTypes(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/car/GetFuelTypes");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        log(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future getTransmissionTypes(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/car/GetTransmissionTypes");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        log(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future getDrivetrainTypes(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/car/GetDrivetrainTypes");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        log(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future getInsuranceTypes(token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/insurance/api/GetInsuranceTypes");
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

  Future addCar(token, data) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/AddCar");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  Future addInsurance(token, data, carId) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/insurance/AddInsurance/$carId");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateInsurance(token, data, carId) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/insurance/UpdateInsurance/$carId");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode(data),
      );
      return response.statusCode;
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateCar(token, data, carId) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/car/UpdateCar/$carId");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode(data),
      );
      return response.statusCode;
    } catch (e) {
      log(e.toString());
    }
  }
  Future deleteCar(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/car/DeleteCar/$id");
      var response = await http.delete(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      return response;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
