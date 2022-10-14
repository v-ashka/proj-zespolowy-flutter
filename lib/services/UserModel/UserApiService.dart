import 'dart:convert';
import 'dart:developer';

import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  Future register(data) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/account/register");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      print(jsonEncode(data));
      if (response.statusCode == 200) {
        // print(response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future login(data) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/account/login");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // print(response.body);
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
