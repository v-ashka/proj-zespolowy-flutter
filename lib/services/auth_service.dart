import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:organizerPRO/constants.dart';

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

  //Funkcja służąca do wysłania żądania zresetowania hasła konta powiązanego z adresem e-mail
  //przekazanym w parametrze jako zmienna email. Gdy użytkownik wybierze opcję przesłania
  //kodu na numer telefonu, parametr isSMS przyjmuje wartość true
  Future<Response?> resetPassword(String? email, bool isSMS) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/resetPassword?email=$email&sendSms=$isSMS";
      response = await dio.post(url);
      return response;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response?> verifyCode(String id, String code) async {
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

    Future setNewPassword(String? resetId, String? token, String? password) async {
    Response response;
    try {
      var url = "$SERVER_IP/api/account/setNewPassword?id=$resetId&token=$token&newPassword=$password";
      response = await Dio().post(
        url,
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
