import 'dart:developer';
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
  // dir = await getApplicationDocumentsDirectory();
  Directory? dir = await getExternalStorageDirectory();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.accessMediaLocation,
    Permission.manageExternalStorage,
    Permission.mediaLibrary,
  ].request();
  print(statuses[Permission.storage]);

  String newPath = "";
  List<String>? dirs = dir?.path.split("/");
//  /storage/emulated/0/Android/data/com.example.projzespoloey/files/

  var indexSearch = dirs?.indexWhere((element) => element == "Android");
  dirs?.removeRange(indexSearch!, dirs.length);

  newPath = dirs!.join('/');
  log("download path: " + newPath.toString());
  dir = Directory(newPath);
  return "${dir.path}/organizerPRO/$filename";
}
