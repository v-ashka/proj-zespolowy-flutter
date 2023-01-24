import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';

// Funkcja wyświetlająca modal z kalendarzem w języku polskim umożliwiającym wybór konkretnej
// daty od roku 1960 do roku następującego 5 lat po roku w którym uruchamiany jest kalendarz.
Future<DateTime?> datePicker(context) {
  var date = showDatePicker(
    locale:  const Locale('pl', 'PL'),
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1960),
    lastDate: DateTime.now().add(const Duration(days: 1825)),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: bgSmokedWhite,
              onSurface: Colors.black, 
            )),
        child: child!,
      );
    },
  );
  return date;
}