import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/dashboard.dart';
import 'package:projzespoloey/pages/userauth.dart';
import 'package:projzespoloey/pages/loading.dart';
import 'package:projzespoloey/pages/carList.dart';
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
        '/carList': (context) => carList(),
        '/': (context) => Loading(),
        '/user_auth': (context) => UserAuth(),
        '/dashboard': (context) => Dashboard()
      },
      title: 'OrganizerPRO',
      theme: ThemeData(
          scaffoldBackgroundColor: primaryColor,
          fontFamily: 'Lato',
          colorScheme: ThemeData().colorScheme.copyWith(primary: primaryColor, secondary: secondaryColor),
          appBarTheme: AppBarTheme(
              color: primaryColor
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
    );
  }
}
