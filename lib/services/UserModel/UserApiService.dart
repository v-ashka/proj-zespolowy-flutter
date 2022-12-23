import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/old_/dashboard.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/dashboard_data_model.dart';

class UserApiService {

  final dio = Dio();
  late Response response;

  Future <Response?> register(data) async {
    try {
      var url = "$SERVER_IP/api/account/register";
      response = await dio.post(
        url,
        data: jsonEncode(data),
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future <Response?> login(data) async {
    try {
      var url = "$SERVER_IP/api/account/login";
      var response = await dio.post(
        url,
        data: jsonEncode(data),
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> resetPassword(email) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/resetPassword?email=$email";
      response = await dio.post(
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
      response = await dio.post(
        url,
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future changePassword(password, token) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/changePassword?newPassword=$password";
      response = await Dio().post(
        url,
        options: Options(
          headers: {
            'Authorization': "Bearer $token",
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future <Response?> getDashboardData(token) async {
    try {
      var response = await Dio().get('$SERVER_IP/api/account/getDashboardData',
          options: Options(headers: {
            'Authorization': "Bearer $token",
          }));
      return response;
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
