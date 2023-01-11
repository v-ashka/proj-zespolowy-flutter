import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/insurace_model.dart';
import 'package:organizerPRO/screens/authorization/user_login.dart';
import 'package:organizerPRO/screens/authorization/user_registration.dart';
import 'package:organizerPRO/screens/authorization/password_reset.dart';
import 'package:organizerPRO/models/car_model.dart';
import 'package:organizerPRO/screens/cars_module/insurance_history_view.dart';
import 'package:organizerPRO/screens/cars_module/car_item_view.dart';
import 'package:organizerPRO/screens/cars_module/car_list_view.dart';
import 'package:organizerPRO/screens/cars_module/car_insurance_view.dart';
import 'package:organizerPRO/screens/cars_module/car_repair_history_view.dart';
import 'package:organizerPRO/screens/files_view.dart';
import 'package:organizerPRO/screens/cars_module/forms/car_form.dart';
import 'package:organizerPRO/screens/cars_module/forms/car_repair_form.dart';
import 'package:organizerPRO/screens/cars_module/forms/inspection_form.dart';
import 'package:organizerPRO/screens/cars_module/forms/insurance_form.dart';
import 'package:organizerPRO/screens/cars_module/inspection_history_view.dart';
import 'package:organizerPRO/screens/cars_module/inspection_view.dart';
import 'package:organizerPRO/screens/dashboard_view.dart';
import 'package:organizerPRO/screens/documents_module/document_item_view.dart';
import 'package:organizerPRO/screens/documents_module/document_form.dart';
import 'package:organizerPRO/screens/documents_module/documents_list_view.dart';
import 'package:organizerPRO/screens/home_module/home_item_view.dart';
import 'package:organizerPRO/screens/home_module/home_list_view.dart';
import 'package:organizerPRO/screens/loading.dart';
import 'package:organizerPRO/screens/receipt_module/receipt_item_view.dart';
import 'package:organizerPRO/screens/receipt_module/receipt_list_view.dart';
import 'package:organizerPRO/screens/receipt_module/receipt_form.dart';


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
  final InsuranceModel model = InsuranceModel();
  final CarModel car = CarModel();
  final String objectId = "";
  final String carModel = "";
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
        '/passwordResetCode': (context) => const PasswordReset(),
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
        '/carForm': (context) => const CarForm(),
        '/formCarInsurance': (context) => InsuranceForm(
              carId: objectId,
            ),
        '/formCarService': (context) => InspectionForm(
              carId: objectId,
            ),
        '/formCarRepair': (context) => CarRepairForm(carId: objectId),
        // Documents Routes
        '/documentList': (context) => const DocumentsList(),
        '/documentItem': (context) => const DocumentItem(),
        '/documentForm': (context) => const DocumentForm(),
        // Home Routes
        '/homeList': (context) => const HomeList(),
        '/homeItem': (context) => HomeItem(homeId: objectId),
        // Receipts Routes
        '/receiptForm': (context) => const ReceiptForm(),
        '/receiptList': (context) => const ReceiptList(),
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
        scaffoldBackgroundColor: const Color(0xFF131313),
      ),
      themeMode: ThemeMode.light,
      theme: ThemeData(
          scaffoldBackgroundColor: primaryColor,
          fontFamily: 'Lato',
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: primaryColor, secondary: mainColor),
          appBarTheme: const AppBarTheme(
              color: primaryColor,
              titleTextStyle: TextStyle(color: fontBlack, fontFamily: "Lato")),
          visualDensity: VisualDensity.adaptivePlatformDensity),
    );
  }
}
