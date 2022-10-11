import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:http/http.dart' as http;

import '../../constants.dart';

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  // getCars(String data) async {
  //   var response = await http.get(
  //     Uri.parse('http://${SERVER_IP}/api/car/GetList'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': "Bearer ${data}",
  //     },
  //   );
  //   print("function");
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     carData["data"] = jsonDecode(response.body);
  //     features = true;
  //   } else {
  //     print("Can't fetch car list!");
  //   }
  // }

  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;
    final size = MediaQuery.of(context).size;
    // print(carData["data"][0]["pojemnoscSilnika"]);
    // print("len: ${carData["data"] == null}");
    print("data test:");
    print(data["user_auth"]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Pojazdy'),
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: Colors.transparent,
            shadowColor: Colors.transparent,
            onSurface: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        foregroundColor:
            Colors.black, //Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: ModuleList(data: data, size: size)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/carForm",
              arguments: {'form_type': 'add_car'});
        },
        backgroundColor: mainColor,
        label: Text('Dodaj nowy'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
