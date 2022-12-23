import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/insurace_model.dart';
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/_userAuth.dart';
import 'package:projzespoloey/pages/otp_screen.dart';
import 'package:projzespoloey/pages/password_reset_code.dart';
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
import 'package:projzespoloey/pages/documentsModule/document_form.dart';
import 'package:projzespoloey/pages/old_/dashboard.dart';
import 'package:projzespoloey/pages/documentsModule/documentItem.dart';
import 'package:projzespoloey/pages/documentsModule/documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeItem.dart';
// import 'package:projzespoloey/pages/_documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/pages/password_reset_code.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptItem.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/pages/old_/userauth.dart';
import 'package:projzespoloey/pages/loading.dart';
import 'package:projzespoloey/pages/form.dart';
import 'package:projzespoloey/pages/receiptsModule/receipt_form.dart';
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
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
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
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pl', 'PL'), // Wspieranie języka polskiego jako lokalnego języka
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        // Widok logowania użytkownika
        '/user_auth': (context) => const UserAuthentication(),
        //Widok resetowania hasła
        '/passwordResetCode': (context) => const PasswordResetCode(),
        // Ekran rejestrowania nowego użytkownika
        '/registerUser': (context) => const UserAuthenticationRegister(),
        //Główny ekran aplikacji - dashboard
        '/dashboard': (context) => const DashboardPanel(),
        // Widok listy dodanych plików
        '/fileList': (context) => FilesView(objectId: objectId),
        // Sciezki powiązane z modułem samochodu
        '/carList': (context) => const CarList(),
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
        '/documentForm': (context) => DocumentForm(),
        // Home Routes
        '/homeList': (context) => HomeList(),
        '/homeItem': (context) => HomeItem(homeId: objectId),
        // Receipts Routes
        '/receiptForm': (context) => ReceiptForm(),
        '/receiptList': (context) => ReceiptList(),
        '/receiptItem': (context) => ReceiptItem(
              receiptId: objectId,
            ),
      },
      title: 'OrganizerPRO',
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        secondaryHeaderColor: Colors.amber,
        primaryColor: Colors.red,
        brightness: Brightness.dark,
        dividerColor: Colors.black12,
        scaffoldBackgroundColor: Color(0xFF131313),
      ),
      themeMode: ThemeMode.light,
      theme: ThemeData(
          scaffoldBackgroundColor: primaryColor,
          fontFamily: 'Lato',
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: primaryColor, secondary: mainColor),
          appBarTheme: AppBarTheme(
              color: primaryColor,
              titleTextStyle: TextStyle(color: fontBlack, fontFamily: "Lato")),
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
