import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: const Center(
          child: CircularProgressIndicator(
          color: mainColor,
          )
        )
      );
  }
}