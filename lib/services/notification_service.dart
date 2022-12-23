import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:projzespoloey/models/notification_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class NotificationApiService {
  
  Future<List<NotificationList>> getNotifications(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/notification/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });

      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      if (response.statusCode == 200) {
        List<NotificationList> list = notificationListFromJson(response.body);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future getCount(token) async {
    try {
      var response = await Dio().get('$SERVER_IP/api/notification/GetCount',
          options: Options(headers: {
            'Authorization': "Bearer $token",
          }));
      return response.data;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
