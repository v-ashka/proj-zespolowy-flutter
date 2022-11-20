import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/insurace_model.dart';
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/_userAuth.dart';
import 'package:projzespoloey/pages/_userAuthRegister.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceHistoryView.dart';
import 'package:projzespoloey/pages/carsModule/car_insurance_view.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/pages/carsModule/car_repair_history_view.dart';
import 'package:projzespoloey/pages/carsModule/form/car_repair_form.dart';
import 'package:projzespoloey/pages/carsModule/inspection_history_view.dart';
import 'package:projzespoloey/pages/carsModule/inspection_view.dart';
import 'package:projzespoloey/pages/carsModule/form/car_form.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceEditForm.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceForm.dart';
import 'package:projzespoloey/pages/old_/dashboard.dart';
import 'package:projzespoloey/pages/documentsModule/documentItem.dart';
import 'package:projzespoloey/pages/documentsModule/documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeItem.dart';
// import 'package:projzespoloey/pages/_documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptItem.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/pages/old_/userauth.dart';
import 'package:projzespoloey/pages/loading.dart';
import 'package:projzespoloey/pages/form.dart';

import 'pages/carsModule/filesView.dart';
import 'pages/carsModule/form/inspection_form.dart';
import 'services/UserModel/UserApiService.dart';

// import 'package:projzespoloey/pages/_carList.dart';
//projzespoloey

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  HttpOverrides.global = PostHttpOverrides();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  InsuranceModel model = InsuranceModel();
  CarModel car = CarModel();
  String objectId = "";
  String carModel = "";
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', 'PL'), // English, no country code
        Locale('en', ''), // Spanish, no country code
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        // User login page
        '/user_auth': (context) => UserAuthentication(),
        // User register page
        '/registerUser': (context) => UserAuthenticationRegister(),
        '/dashboard': (context) => DashboardPanel(),
        '/form': (context) => DataForm(),
        //File list
        '/fileList': (context) => FilesView(objectId: objectId),
        // Car Routes
        '/carList': (context) => CarList(),
        '/carItem': (context) => CarItem(carId: objectId),
        '/carInsurance': (context) => CarInsuranceView(
              car: car,
            ),
        '/carInsuranceEditForm': (context) =>
            InsuranceEditForm(insurance: model, carId: objectId),
        '/carInsuranceHistory': (context) => CarInsuranceHistoryView(
              car: car,
            ),
        '/carService': (context) => CarServiceView(
              car: car,
            ),
        '/carServiceHistory': (context) =>
            InspectionHistory(carId: objectId, carModel: carModel),
        '/carRepairHistory': (context) => CarRepairHistoryView(
              car: car,
            ),
        // Car form Route
        '/carForm': (context) => CarForm(),
        '/formCarInsurance': (context) => InsuranceForm(
              carId: objectId,
            ),
        '/formCarService': (context) => InspectionForm(
              carId: objectId,
            ),
        '/formCarRepair': (context) => CarRepairForm(carId: objectId),
        // Documents Routes
        '/documentList': (context) => DocumentsList(),
        '/documentItem': (context) => DocumentItem(),
        // Home Routes
        '/homeList': (context) => HomeList(),
        '/homeItem': (context) => HomeItem(),
        // Receipts Routes
        '/receiptList': (context) => ReceiptList(),
        '/receiptItem': (context) => ReceiptItem(),
      },
      title: 'OrganizerPRO',
      theme: ThemeData(
          scaffoldBackgroundColor: primaryColor,
          fontFamily: 'Lato',
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: primaryColor, secondary: secondaryColor),
          appBarTheme: AppBarTheme(
              color: primaryColor,
              titleTextStyle: TextStyle(color: fontBlack, fontFamily: "Lato")),
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
