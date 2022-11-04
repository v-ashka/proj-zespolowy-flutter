import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/insurance/insurace_model.dart';


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

  Future<InsuranceModel> getValidOC(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/insurance/GetValidOC/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        log(response.body.toString());
        Map<String, dynamic> data = jsonDecode(response.body);
        InsuranceModel model = InsuranceModel.fromJson(data);
        return model;
      } else {
        return InsuranceModel();
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Błąd pobierania danych');
    }
  }

Future<InsuranceModel> getValidAC(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/insurance/GetValidAC/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        log(response.body.toString());
        Map<String, dynamic> data = jsonDecode(response.body);
        InsuranceModel model = InsuranceModel.fromJson(data);
        return model;
      } else {
        return InsuranceModel();
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Błąd pobierania danych');
    }
    
  }
    Future getInsuranceList(token, carId) async {
    try {
      List<InsuranceModel> model;
      var url = Uri.parse("$SERVER_IP/api/insurance/GetInsuranceList/$carId");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${token}",
        },
      );
      if (response.statusCode == 200) {
        model = insuranceListFromJson(response.body);
        return model;
      }
      return response;

    } catch (e) {
      log(e.toString());
    }
    
  }

  Future deleteInsurance(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/insurance/DeleteInsurance/$id");
      var response = await http.delete(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }