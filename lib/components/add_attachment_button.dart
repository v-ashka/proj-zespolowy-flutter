import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/utils/file_picker.dart';

enum FormType { car, insurance, inspection, repair, receipt, document, home }

extension FormTypeExtension on FormType {
  String get text {
    switch (this) {
      case FormType.car:
        return 'pojazdu';
      case FormType.insurance:
        return 'polisy';
      case FormType.inspection:
        return 'przeglądu';
      case FormType.repair:
        return 'naprawy';
      case FormType.receipt:
        return 'paragonu';
      case FormType.document:
        return 'dokumentu';
      case FormType.home:
        return 'domu';

    }
  }
}

class AddAttachmentButton extends StatefulWidget {
  final ValueChanged<List<PlatformFile>>? onChanged;
  final FormType formType;

  const AddAttachmentButton(
      {Key? key, required this.formType, required this.onChanged})
      : super(key: key);

  @override
  State<AddAttachmentButton> createState() => _AddAttachmentButtonState();
}

class _AddAttachmentButtonState extends State<AddAttachmentButton> {
  List<PlatformFile> files = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondColor,
                foregroundColor: bgSmokedWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: () async {
                files = await filePicker(files);
                setState(() {
                  widget.onChanged!(files);
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.file_upload_outlined),
                  const SizedBox(width: 2),
                  Text(
                      files.isEmpty
                          ? "Dodaj załączniki do ${widget.formType.text}"
                          : files.length == 1
                              ? "Dodano 1 załącznik do ${widget.formType.text}"
                              : files.length < 5
                                  ? "Dodano ${files.length} załączniki do ${widget.formType.text}"
                                  : "Dodano ${files.length} załączników do ${widget.formType.text}",
                      style: const TextStyle(fontWeight: FontWeight.w600))
                ],
              )),
        ],
      ),
    );
  }
}
