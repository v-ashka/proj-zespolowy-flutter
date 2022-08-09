import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Map dataTemp = {};

  void getData() async{
   // print("start loading");
   Future.delayed(Duration(seconds: 1), (){
     Navigator.pushReplacementNamed(context, '/user_auth', arguments: {
       'userList': dataTemp,
     });
   });
    //print("end loading (success/failed)");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SpinKitDancingSquare(
          color: secondaryColor,
          size: 150,
        ),
      ),
    );
  }
}
