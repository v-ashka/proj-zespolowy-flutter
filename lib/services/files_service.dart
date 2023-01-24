import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/file_model.dart';
import 'dart:io';

class FilesService {
  Future<List<FileList>?> getFileList(token, id) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/fileUpload/GetFileList/$id");
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        List<FileList> model = fileListFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future uploadFile(token, path, id) async {
    try {
      var url = Uri.parse(
          "$SERVER_IP/api/fileUpload/UploadFile?rootFolder=samochod&nazwaFolderu=$id&czyNaglowkowy=true");
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', path));
      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future uploadFiles(token, List<PlatformFile> files, id) async {
    dynamic response;
    for (var item in files) {
      var file = File(item.path!);
      try {
        var url = Uri.parse(
            "$SERVER_IP/api/fileUpload/UploadFile?rootFolder=pliki&nazwaFolderu=$id&czyNaglowkowy=false");
        var request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        response = await request.send();
      } catch (e) {
        log(e.toString());
        return false;
      }
    }
    return response;
  }

  Future importFiles(token, file) async {
    try {
      var url = Uri.parse("$SERVER_IP/api/fileUpload/ImportData");
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
