import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

Future<List<PlatformFile>> filePicker(List<PlatformFile> fileList) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) {
    if (fileList.isNotEmpty) {
      fileList.clear();
    }
    return fileList = result.files;
  } else {
    return fileList = [];
  }
}

Future<String> getFilePath(String filename) async {
  dynamic dir = "";
  dir = await getApplicationDocumentsDirectory();
  log("download path: " + dir.toString());
  return "${dir.path}/$filename";
}
