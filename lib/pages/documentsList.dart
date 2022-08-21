import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import "package:projzespoloey/components/module_list.dart";

class DocumentsList extends StatefulWidget {
  const DocumentsList({Key? key}) : super(key: key);

  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  Map data = {};
  @override
  Widget build(BuildContext context) {
  data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
  final size = MediaQuery.of(context).size;

  return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:  AppBar(
        elevation: 0,
        title: Text('Dokumenty'),
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