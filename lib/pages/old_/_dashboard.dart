import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/container.dart';
import 'package:projzespoloey/components/header.dart';
import 'package:projzespoloey/constants.dart';
// db class
import 'package:projzespoloey/pages/old_/db_provider.dart';
import 'package:projzespoloey/pages/old_/user.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map data = {};

  void testDatabse() async{
    var pojazd1 = Car(name: 'polonez', engine: '1.6ohv', productionDate: '2022-05-25', imageUrl: 'polonez');
    await DbProvider.db.createUsers(pojazd1);
    print("powinno byc: $pojazd1 i 0");
  }

  void showResult() async{
    var test = await DbProvider.db.getData();
    print("rs: $test" );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
    Size? size = MediaQuery.of(context).size;

    print("isReceiptVisible? :${data['userData']['settings']['receiptVisible']}");
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.fill)
          ),
          child: Stack(
            children: [
              Header(
                data: data,
                size: size,
              ),
              DashboardContainer(
                data: data,
                size: size,
              )
            ],
          ),
        )
      ),
    );
  }
}
