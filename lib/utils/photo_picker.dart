import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future <File?> pickImage() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (result != null) {
    return File(result.files.single.path!);
  }
  return null; 
}

Future <List<PlatformFile>> pickImages(List<PlatformFile> fileList) async {
  FilePickerResult? result =
  await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
  if (result != null) {
    if (fileList.isNotEmpty) {
      fileList.clear();
    }
    return fileList = result.files;
  } else {
    return fileList = [];
  }
}

