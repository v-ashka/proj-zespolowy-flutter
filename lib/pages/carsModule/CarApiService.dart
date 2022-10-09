import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'Car.dart';
import 'package:projzespoloey/constants.dart';

class CarApiService {
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

  Future<List<dynamic>> getCarInsurance(token, carId) async {
    try {
      List _model = ["test"];
      var url = Uri.parse("${SERVER_IP}/api/car/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        _model = jsonDecode(response.body);
      }
      print(response.statusCode);
      return _model;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
