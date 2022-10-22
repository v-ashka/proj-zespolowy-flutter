import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
        // var id = 2;
        List<CarModel> _model = carModelFromJson(response.body);
        return _model;
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
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<InsuranceFormModel> getValidInsurance(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/insurance/GetValidInsurance/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        log(response.body.toString());
        Map<String, dynamic> data = jsonDecode(response.body);
        InsuranceFormModel model = InsuranceFormModel.fromJson(data);
        return model;
      } else {
        return InsuranceFormModel();
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Błąd pobierania danych');
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

  Future getModeleMarki(token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/car/api/Markimodele");
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

  Future<List<FileList>?> GetFileList(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/fileUpload/GetFileList/$id");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
      );
      if (response.statusCode == 200) {
        List<FileList> _model = fileListFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future uploadFile(token, path, id) async {
    try {
      var url = Uri.parse(
          "${SERVER_IP}/api/fileUpload/UploadFile?rootFolder=samochod&nazwaFolderu=$id&czyNaglowkowy=true");
      print(url);
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', path));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded!');
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future uploadFiles(token, List<PlatformFile> files, id) async {
    for (var item in files) {
      var file = File(item.path!);
      try {
        var url = Uri.parse(
            "${SERVER_IP}/api/fileUpload/UploadFile?rootFolder=pliki&nazwaFolderu=$id&czyNaglowkowy=false");
        print(url);
        var request = http.MultipartRequest('POST', url);
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          print('File uploaded!');
          return true;
        } else {
          print(response.statusCode);
          return false;
        }
      } catch (e) {
        log(e.toString());
        return false;
      }
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

  Future addService(token, data, carId) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/inspection/$carId/AddInspection");
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
}
