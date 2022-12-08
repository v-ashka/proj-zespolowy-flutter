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

  Future<HomeModel?> getHome(id, token) async {
    try {
      var url = Uri.parse("${SERVER_IP}/api/home/GetHome/${id}");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      });

      log(id.toString());
      if (response.statusCode == 200) {
        var home = jsonDecode(response.body);
        return HomeModel.fromJson(home);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
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

  Future<Response?> addRoom(HomeModel data, token) async {
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

  Future<List<HomeListView>?> getHomeList(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/home/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        List<HomeListView> list = homeListViewFromJson(response.body);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
