import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/room_model.dart';

class RoomService {
  final _dio = Dio();

  Future<Response?> addRoom(String homeId, String name, String token) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/home/AddRoom?idDomu=$homeId&nazwa=$name";
      response = await _dio.post(
          url,
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

  Future<List<RoomModel>?> getRoomList(String homeId, String? token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/home/GetRoomsList?idDomu=$homeId");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });
      if (response.statusCode == 200) {
        List<RoomModel> list = roomListFromJson(response.body);
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
