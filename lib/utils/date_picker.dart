import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

Future<DateTime?> pickDate(context) {
  var date = showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1960),
    lastDate: DateTime(2026),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainColor, // header background color
              onPrimary: bgSmokedWhite, // header text color
              onSurface: Colors.black, // body text color
            )),
        child: child!,
      );
    },
  );
  return date;
}