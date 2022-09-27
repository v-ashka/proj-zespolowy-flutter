import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceHistoryView.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceView.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/pages/carsModule/carRepairHistory.dart';
import 'package:projzespoloey/pages/carsModule/carServiceHistory.dart';
import 'package:projzespoloey/pages/carsModule/carServiceView.dart';
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

// import 'package:projzespoloey/pages/_carList.dart';
//projzespoloey
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/user_auth': (context) => UserAuth(),
        '/dashboard': (context) => Dashboard(),
        '/form': (context) => DataForm(),
        // Car Routes
        '/carList': (context) => CarList(),
        '/carItem': (context) => CarItem(),
        '/carInsurance': (context) => CarInsuranceView(),
        '/carInsuranceHistory': (context) => CarInsuranceHistoryView(),
        '/carService': (context) => CarServiceView(),
        '/carServiceHistory': (context) => CarServiceHistory(),
        '/carRepairHistory': (context) => CarRepairHistoryView(),
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
