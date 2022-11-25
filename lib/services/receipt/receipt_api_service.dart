import 'dart:convert';
import 'dart:developer';

import 'package:projzespoloey/models/receipts/receipt_list_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/models/receipts/receipt_model.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import '../../constants.dart';
import '../../models/receipts/receipt_model_form.dart';

class ReceiptApiService {
  Future<List<ReceiptListView>> getReceipts(token) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/receipt/GetList");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      });

      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      if (response.statusCode == 200) {
        List<ReceiptListView> list = receiptListViewFromJson(response.body);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<ReceiptModel?> getReceipt(String? token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/receipt/GetRecipt/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      });

      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      if (response.statusCode == 200) {
        return ReceiptModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ReceiptModelForm?> getReceiptFormData(String? token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/receipt/GetRecipt/$id");
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      });

      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      if (response.statusCode == 200) {
        return ReceiptModelForm.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future addReceipt(token, data) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/receipt/AddRecipt");
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future updateReceipt(token, data, receiptId) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/receipt/UpdateRecipt/$receiptId");
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(data),
      );
      log(response.statusCode.toString());
      log(response.reasonPhrase.toString());
      return response.statusCode;
    } catch (e) {
      log(e.toString());
    }
  }
}
