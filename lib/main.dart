import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/insurace_model.dart';
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/_userAuth.dart';
import 'package:projzespoloey/pages/_userAuthRegister.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceHistoryView.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceView.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/pages/carsModule/carRepairHistory.dart';
import 'package:projzespoloey/pages/carsModule/carServiceHistory.dart';
import 'package:projzespoloey/pages/carsModule/inspection_view.dart';
import 'package:projzespoloey/pages/carsModule/form/carForm.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceEditForm.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceForm.dart';
import 'package:projzespoloey/pages/dashboard.dart';
import 'package:projzespoloey/pages/documentsModule/documentItem.dart';
import 'package:projzespoloey/pages/documentsModule/documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeItem.dart';
// import 'package:projzespoloey/pages/_documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptItem.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/pages/userauth.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  InsuranceModel model = InsuranceModel();
  String carId = "";
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/fileList': (context) => FilesView(),
        // Car Routes
        '/carList': (context) => CarList(),
        '/carItem': (context) => CarItem(carId: carId),
        '/carInsurance': (context) => CarInsuranceView(),
        '/carInsuranceEditForm': (context) =>
            InsuranceEditForm(insurance: model, carId: carId),
        '/carInsuranceHistory': (context) => CarInsuranceHistoryView(),
        '/carService': (context) => CarServiceView(),
        '/carServiceHistory': (context) => CarServiceHistory(),
        '/carRepairHistory': (context) => CarRepairHistoryView(),
        // Car form Route
        '/carForm': (context) => CarForm(),
        '/formCarInsurance': (context) => InsuranceForm(),
        '/formCarService': (context) => InspectionForm(),
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
