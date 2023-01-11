import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/screens/files_view.dart';

class FilesButton extends StatelessWidget {
  final String objectId;
  const FilesButton({Key? key, required this.objectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(100),
          )),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilesView(
                  objectId: objectId),
            ));
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: secondColor,
        ),
        child: const Icon(
          Icons.file_open_outlined,
          size: 30,
          color: bgSmokedWhite,
        ),
      ),
    );
  }
}
