import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/document_model.dart';

class DocumentService {
  Future addDocument(token, data) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/document/AddDocument/");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      log(e.toString());
    }
  }

  Future deleteDocument(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/document/DeleteDocument/$id");
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
  }

  Future updateDocument(token, data, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/document/UpdateDocument/$id");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      return response.body;
    } catch (e) {
      log(e.toString());
    }
  }

  Future getDocumentList(token) async {
    try {
      List<DocumentModel>? model;
      var url =
      Uri.parse("$SERVER_IP/api/document/GetList/");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        model = documentListFromJson(response.body);
        return model;
      }
      return model;
    } catch (e) {
      log(e.toString());
    }
  }

  Future getCategories(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/document/GetCategories");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
