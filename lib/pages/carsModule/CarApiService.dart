import 'dart:developer';

import 'package:http/http.dart' as http;
import 'Car.dart';
import 'package:projzespoloey/constants.dart';

class CarApiService {
  Future<List<CarModel>?> getCars(token) async {
    try {
      var url = Uri.parse("http://${SERVER_IP}/api/car/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      if (response.statusCode == 200) {
        getToken(token);
        List<CarModel> _model = carModelFromJson(response.body);
        return _model;
      }

      print(response.statusCode);
    } catch (e) {
      log(e.toString());
    }
  }
}
