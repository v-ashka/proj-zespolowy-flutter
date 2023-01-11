import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/main.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/utils/date_picker.dart';
import '../../../models/insurace_model.dart';
import '../../../utils/file_picker.dart';

class InsuranceForm extends StatefulWidget {
  final String? carId;
  final bool? isEditing;
  final InsuranceModel? editModel;
  const InsuranceForm(
      {Key? key, required this.carId, this.isEditing = false, this.editModel})
      : super(key: key);

  @override
  State<InsuranceForm> createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<InsuranceForm> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  var insuranceTypesList = [];
  String? dateFrom;
  String? dateTo;
  InsuranceModel insurance = InsuranceModel();
  List<PlatformFile> files = [];

  void _getInsuranceTypes() async {
    String? tokenVal = await storage.read(key: "token");
    insuranceTypesList = (await CarApiService().getInsuranceTypes(tokenVal));
    setState(() {});
  }

  void checkIfEditForm(isEdit, editModel) async {
    if (isEdit) {
      insurance = editModel;
    }
  }

  @override
  void initState() {
    super.initState();
    _getInsuranceTypes();
    checkIfEditForm(widget.isEditing, widget.editModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing!
              ? (HeaderTitleType.formEditInsurance)
              : (HeaderTitleType.formAddInsurance)),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                    child: Column(
                      // padding: EdgeInsets.only(bottom: 10),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 12,
                              child: Text(
                                "Wprowadź dane polisy",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text(
                                "Rodzaj ubezpieczenia",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                value: insurance.idRodzajuUbezpieczenia,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    insurance.idRodzajuUbezpieczenia =
                                        value as int?;
                                  });
                                },
                                items: insuranceTypesList.map((insurance) {
                                  return DropdownMenuItem(
                                      value: insurance['id'],
                                      child: Text(insurance['nazwa']));
                                }).toList(),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.car_repair,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wybierz rodzaj ubezpieczenia",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text(
                                "Ubezpieczyciel",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: insurance.ubezpieczyciel ?? "",
                              onSaved: (String? value) {
                                insurance.ubezpieczyciel = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.business_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Nazwa ubezpieczyciela",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Numer polisy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: insurance.nrPolisy ?? "",
                              onSaved: (String? value) {
                                insurance.nrPolisy = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.pin_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Podaj numer polisy",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Okres ubezpieczenia",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: TextFormField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                              await datePicker(context);
                                          setState(() {
                                            insurance.dataZakupu =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(date!);
                                          });
                                        },
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText:
                                                insurance.dataZakupu ?? "Od",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (date) {
                                          if (insurance.dataZakupu == null) {
                                            return 'To pole nie może być puste';
                                          }
                                          return null;
                                        }),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 26, 0, 5),
                                    child: SizedBox(
                                      width: 160,
                                      child: TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? date =
                                                await datePicker(context);
                                            setState(() {
                                              insurance.dataKonca =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(date!);
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              hintText:
                                                  insurance.dataKonca ?? "Do",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (date) {
                                            if (insurance.dataKonca == null) {
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Koszt polisy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextFormField(
                                  initialValue: widget.isEditing!
                                      ? (insurance.kosztPolisy.toString())
                                      : (''),
                                  keyboardType: TextInputType.number,
                                  onSaved: (String? value) {
                                    insurance.kosztPolisy = int.parse(value!);
                                  },
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      suffixText: "zł",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 1, 20, 1),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(top: 1),
                                        child: Icon(
                                          Icons.attach_money_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Podaj koszt polisy",
                                      fillColor: bg35Grey,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'To pole nie może być puste';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                        if (!widget.isEditing!)
                          AddAttachmentButton(
                              //files: files,
                              formType: FormType.insurance,
                              onChanged: (filesList) {
                                files = filesList;
                              })
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(insurance.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? tokenVal = await storage.read(key: "token");
            if (!widget.isEditing!) {
              await CarApiService()
                  .addInsurance(tokenVal, insurance, widget.carId);
            } else {
              await CarApiService().updateInsurance(
                  tokenVal, insurance, insurance.idUbezpieczenia);
            }

            setState(() {
              Navigator.of(context).pop(CarItem(carId: widget.carId!));
            });
          }
        },
        backgroundColor: mainColor,
        label: Text(widget.isEditing!
            ? ("Zapisz ubezpieczenie")
            : ("Dodaj ubezpieczenie")),
        icon: Icon(Icons.check),
      ),
    );
  }
}
