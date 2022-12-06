import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:projzespoloey/components/header.dart';
import 'package:projzespoloey/constants.dart';

enum HeaderTitleType {
  defaultTitle,
  settingsTitle,
  carList,
  carDefault,
  carInsurance,
  carInsuracneHistory,
  carInspection,
  carInsepctionHistory,
  carRepair,
  receipt,
  formAddCar,
  formAddInsurance,
  formAddInspection,
  formAddRepair,
  formEditCar,
  formEditInsurance,
  formEditInspection,
  formEditRepair,
  fileList,
  documentList,
  formAddDocument,
  formEditDocument,
  passwordResetCode,
  homeList,
  formAddHome,
  formEditHome,
  notification
}

extension HeaderTitleExtension on HeaderTitleType {
  String get text {
    switch (this) {
      case HeaderTitleType.settingsTitle:
        return 'Ustawienia';
      case HeaderTitleType.fileList:
        return 'Lista plików';
      case HeaderTitleType.defaultTitle:
        return '';
      case HeaderTitleType.carList:
        return 'Lista pojazdów';
      case HeaderTitleType.carDefault:
        return 'Pojazd';
      case HeaderTitleType.carInsurance:
        return 'Ubezpieczenie';
      case HeaderTitleType.carInsuracneHistory:
        return 'Historia ubezpieczeń';
      case HeaderTitleType.carInspection:
        return 'Przegląd';
      case HeaderTitleType.carInsepctionHistory:
        return 'Historia przeglądów';
      case HeaderTitleType.carRepair:
        return 'Historia napraw';
      case HeaderTitleType.receipt:
        return 'Paragon';
      case HeaderTitleType.formAddCar:
        return 'Dodaj nowy pojazd';
      case HeaderTitleType.formAddInsurance:
        return 'Dodaj nowe ubezpieczenie';
      case HeaderTitleType.formAddInspection:
        return 'Dodaj nowy przegląd';
      case HeaderTitleType.formAddRepair:
        return 'Dodaj nową naprawę';
      case HeaderTitleType.formEditCar:
        return 'Edytuj samochód';
      case HeaderTitleType.formEditInsurance:
        return 'Edytuj ubezpieczenie';
      case HeaderTitleType.formEditInspection:
        return 'Edytuj przegląd';
      case HeaderTitleType.formEditRepair:
        return 'Edytuj naprawę';
      case HeaderTitleType.documentList:
        return 'Dokumenty';
      case HeaderTitleType.formAddDocument:
        return 'Dodaj nowy dokument';
      case HeaderTitleType.formEditDocument:
        return 'Edytuj dokument';
      case HeaderTitleType.passwordResetCode:
        return 'Wróć do logowania';
      case HeaderTitleType.homeList:
        return 'Lista domów';
      case HeaderTitleType.formEditHome:
        return 'Edytuj dom';
      case HeaderTitleType.formAddHome:
        return 'Dodaj dom';
      case HeaderTitleType.notification:
        return 'Powiadomienia';
    }
  }
}

PreferredSizeWidget myAppBar(BuildContext context, HeaderTitleType titleType,
    [String? additionalChar,
    String? firstParam,
    String? secondParam,
    HeaderTitleType? additionalText]) {
  return AppBar(
    elevation: 0.0,
    leading: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        HapticFeedback.heavyImpact();
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
    ),
    foregroundColor: secondaryColor,
    backgroundColor: secondaryColor,
    shadowColor: Colors.transparent,
    titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Lato',
        fontSize: MediaQuery.of(context).textScaleFactor * 17,
        color: Colors.black),
    title: Text(
        "${titleType.text} ${additionalChar ?? ""} ${additionalText?.text ?? ""} ${firstParam ?? ""} ${secondParam ?? ""}"),
  );
}
