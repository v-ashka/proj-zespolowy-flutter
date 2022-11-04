import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';

class InspectionApiService {
  Future getService(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/GetInspectionsList/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future addService(token, data, carId) async {
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

  Future deleteService(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/inspection/DeleteInsepction/$id");
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future updateService(token, data, id) async {
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
}
