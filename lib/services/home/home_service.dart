import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:projzespoloey/models/home/home_model.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';

import '../../constants.dart';

class HomeApiService {
  Future<List<HomeListView>> getHomeList(token) async {
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
