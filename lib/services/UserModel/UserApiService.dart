import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  final _dio = Dio();
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
        return {"data": response.body, "message": "Pomyślnie zarejestrowano!"};
      } else {
        return {
          "data": null,
          "message": "Wystapił błąd połączenia z bazą danych!"
        };
      }
    } catch (e) {
      log(e.toString());
      return {
        "data": null,
        "message": "Nie można zapisać danych, sprawdź połączenie internetowe!"
      };
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
        storage.write(key: "token", value: response.body);
        return {"data": response.body};
      } else {
        return {"data": null, "message": "Podano nie prawidłowe dane!"};
      }
    } catch (e) {
      log(e.toString());
      return {"data": null, "message": "Wystapił błąd połączenia!"};
    }
  }

  Future<Response> resetPassword(email) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/resetPassword?email=$email";
      response = await _dio.post(
        url,
      );
      return response;
    } on DioError catch (e) {
      throw Exception("Wystąpił błąd");
    }
  }

  Future<Response?> verifyCode(String id, int code) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/confirmReset?id=$id&code=$code";
      response = await _dio.post(
        url,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future changePassword(data) async {
    try {
      // check old pass
      UserLogin userLogin = UserLogin(email: data.email, pass: data.oldPass);
      var url = Uri.parse("$SERVER_IP/api/account/login");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userLogin),
      );
      print(response.statusCode);
      print(jsonEncode(userLogin));
      if (response.statusCode == 200) {
        // var urlPass =
        //     "$SERVER_IP/api/account/changePassword?newPassword=${data.newPass}";
        // var responsePass = await _dio.post(
        //   urlPass,
        // );
        var responsePass = 200;
        print(responsePass);
        if (responsePass == 200) {
          return true;
        }
      }
      return false;
    } on DioError catch (e) {
      return e.response;
    }
  }
}

class UserAuthenticate {
  UserAuthenticate({required this.token, required this.payload});
  final String? token;
  final Map payload;

  String? get getToken {
    return token;
  }

  Map get getPayload {
    return payload;
  }
}
