import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/dashboard.dart';
import 'package:projzespoloey/pages/userauth.dart';
import 'package:projzespoloey/pages/loading.dart';
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
      },
      title: 'myOrganizer',
      theme: ThemeData(
          scaffoldBackgroundColor: primaryCol,
          colorScheme: ThemeData().colorScheme.copyWith(primary: primaryCol),
          appBarTheme: AppBarTheme(
              color: primaryCol
          ),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: primaryBgCol),
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
    );
  }
}
