import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Directory? dir = await getExternalStorageDirectory();
  await [
    Permission.storage,
    Permission.accessMediaLocation,
    Permission.manageExternalStorage,
    Permission.mediaLibrary,
  ].request();
  String newPath = "";
  List<String>? dirs = dir?.path.split("/");
  var indexSearch = dirs?.indexWhere((element) => element == "Android");
  dirs?.removeRange(indexSearch!, dirs.length);

  newPath = dirs!.join('/');
  dir = Directory(newPath);
  return "${dir.path}/organizerPRO/$filename";
}
