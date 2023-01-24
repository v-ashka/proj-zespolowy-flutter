import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';

class EditButton extends StatelessWidget {
  final Function() callback;
  const EditButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: mainColor,
          padding: EdgeInsets.all(5),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          )),
      onPressed: callback.call(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: mainColor,
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: 30,
          color: bgSmokedWhite,
        ),
      ),
    );
  }
}
