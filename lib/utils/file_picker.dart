import 'package:file_picker/file_picker.dart';

Future <List<PlatformFile>> pickFiles(List<PlatformFile> fileList) async {
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
