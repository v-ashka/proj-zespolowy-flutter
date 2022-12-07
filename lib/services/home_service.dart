import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/file_model.dart';
import 'package:projzespoloey/models/home_model.dart';
import 'package:projzespoloey/models/insurace_model.dart';

class HomeService {
  final _dio = Dio();

  Future getHomeTypes(token) async {
    try {
      var url = "$SERVER_IP/api/home/GetHomeTypes";
      var response = await _dio.get(url,
          options: Options(
            headers: {
              'Authorization': "Bearer $token",
            },
          ));
      return response.data;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> addHome(HomeModel data, token) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/home/AddHome";
      response = await _dio.post(
        url,
        data: jsonEncode(data),
          options: Options(
            headers: {
              'Authorization': "Bearer $token",
            },
          ));
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> updateHome(HomeModel data, token, id) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/home/UpdateHome/$id";
      response = await _dio.put(
          url,
          data: jsonEncode(data),
          options: Options(
            headers: {
              'Authorization': "Bearer $token",
            },
          ));
      return response;
    } on DioError catch (e) {
      return e.response;
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
