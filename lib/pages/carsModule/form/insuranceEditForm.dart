import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:file_picker/file_picker.dart';

class InsuranceEditForm extends StatefulWidget {

  InsuranceFormModel data;
  InsuranceEditForm({Key? key, required this.data}) : super(key: key);

  @override
  State<InsuranceEditForm> createState() => _InsuranceEditFormState();

}

class _InsuranceEditFormState extends State<InsuranceEditForm> {
  final storage = new FlutterSecureStorage();
  Map item = {};
  InsuranceFormModel? insurance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        insurance = widget.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(insurance?.Ubezpieczyciel);
    return Container();
  }
}
