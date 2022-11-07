import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/inspection_model.dart';

class InspectionApiService {
  
  Future<InspectionModel?> getInspection(token, id) async {
    InspectionModel inspection = InspectionModel();
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/GetValidInspection/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        inspection = InspectionModel.fromJson(data);
        return inspection;
      }
      return inspection;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future addInspection(token, data, carId) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/AddInspection/$carId");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      log(e.toString());
    }
  }

  Future deleteInspection(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/DeleteInsepction/$id");
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

  Future updateInspection(token, data, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/UpdateInspection/$id");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      log(e.toString());
    }
  }
  Future getInspectionList(token, carId) async {
    try {
      List<InspectionModel> model;
      var url = Uri.parse("$SERVER_IP/api/inspection/GetInspectionsList/$carId");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
      );
      if (response.statusCode == 200) {
        model = inspectionListFromJson(response.body);
        return model;
      }
      return response;

    } catch (e) {
      log(e.toString());
    }
  }
}
