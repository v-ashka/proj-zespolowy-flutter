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
