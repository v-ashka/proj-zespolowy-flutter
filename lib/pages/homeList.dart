import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import "package:projzespoloey/components/module_list.dart";

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => HomeListState();
}

class HomeListState extends State<HomeList> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
  data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
  final size = MediaQuery.of(context).size;

  return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:  AppBar(
        elevation: 0,
        title: Text('Sprzęt domowy'),
        leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Colors.black,//Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato', fontSize: MediaQuery.of(context).textScaleFactor * 20, color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/background.png'), fit: BoxFit.fill)
        ),
        child: ModuleList(data: data, size: size),
      )
    );
  }
}