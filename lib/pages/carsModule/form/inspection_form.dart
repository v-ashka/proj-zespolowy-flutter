import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/inspection_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';

class InspectionForm extends StatefulWidget {
  final String carId;
  final bool? isEditing;
  final InspectionModel? editModel;
  const InspectionForm(
      {Key? key, required this.carId, this.isEditing = false, this.editModel})
      : super(key: key);

  @override
  State<InspectionForm> createState() => _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfEditForm(widget.isEditing, widget.editModel);
  }

  var inspectionStatus = [
    {"title": "Pozytywny", "status": true},
    {"title": "Negatywny", "status": false}
  ];
  InspectionModel inspection = InspectionModel();

  List<PlatformFile> files = [];

  void checkIfEditForm(isEdit, editModel) async {
    if (isEdit) {
      inspection = editModel;
    }
  }

  Future<DateTime?> pickDate(context) {
    var date = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2023),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
            primary: mainColor, // header background color
            onPrimary: bgSmokedWhite, // header text color
            onSurface: Colors.black, // body text color
          )),
          child: child!,
        );
      },
    );
    return date;
  }

  Future pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        if (files.isNotEmpty) {
          files.clear();
        }
        //files = result.paths.map((path) => File(path!)).toList();
        files = result.files;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing!
              ? (HeaderTitleType.formEditInspection)
              : (HeaderTitleType.formAddInspection)),
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
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                "Wprowadź badanie techiczne",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Nazwa stacji diagnostycznej",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                initialValue:
                                    inspection.nazwaStacjiDiagnostycznej ?? "",
                                onSaved: (String? value) {
                                  inspection.nazwaStacjiDiagnostycznej = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.warehouse,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Nazwa stacji diagnostycznej",
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
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 350,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Zarejestrowany przebieg",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Numer badania",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          initialValue: widget.isEditing!
                                              ? (inspection
                                                  .zarejestrowanyPrzebieg
                                                  .toString())
                                              : (''),
                                          onSaved: (String? value) {
                                            inspection.zarejestrowanyPrzebieg =
                                                int.parse(value!);
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(1),
                                              prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.edit_road_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Przebieg auta",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          }),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                            initialValue:
                                                inspection.numerBadania ?? "",
                                            onSaved: (String? value) {
                                              inspection.numerBadania = value;
                                            },
                                            cursorColor: Colors.black,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                prefixIcon: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1),
                                                  child: Icon(
                                                    Icons.numbers_outlined,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                hintText: "Nr badania",
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
                                                fillColor: bg35Grey,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                )),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'To pole nie może być puste';
                                              }
                                              return null;
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text(
                                "Wynik badania pojazdu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Proszę wybrać wynik badania!';
                                  }
                                  return null;
                                },
                                value: inspection.czyPozytywny,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    inspection.czyPozytywny = value as bool;
                                  });
                                },
                                items: inspectionStatus.map((insStatus) {
                                  return DropdownMenuItem(
                                      value: insStatus['status'],
                                      child: Text("${insStatus["title"]}"));
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
                                    hintText: "Wybierz wynik badania",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 310,
                                    height: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Data zatwierdzenia przeglądu",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: Text(
                                              "Data następnego przeglądu",
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 310,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? date =
                                                    await pickDate(context);
                                                setState(() {
                                                  inspection.dataPrzegladu =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date!);
                                                });
                                              },
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: inspection
                                                          .dataPrzegladu ??
                                                      "Data zatwierdzenia",
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                              validator: (date) {
                                                if (inspection.dataPrzegladu ==
                                                    null) {
                                                  return 'To pole nie może być puste';
                                                }
                                                return null;
                                              }),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? date =
                                                    await pickDate(context);
                                                setState(() {
                                                  inspection
                                                          .koniecWaznosciPrzegladu =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date!);
                                                });
                                              },
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: inspection
                                                          .koniecWaznosciPrzegladu ??
                                                      "Data kolejnego badania",
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                              validator: (date) {
                                                if (inspection
                                                        .koniecWaznosciPrzegladu ==
                                                    null) {
                                                  return 'To pole nie może być puste';
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Uwagi do przeglądu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextFormField(
                                initialValue: inspection.uwagi ?? "",
                                maxLines: 4,
                                onSaved: (String? value) {
                                  inspection.uwagi = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    hintText: "Dodaj uwagi do przeglądu...",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        if (!widget.isEditing!) ...[
                          AddAttachmentButton(
                              files: files, formType: FormType.inspection)
                        ]
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
          print(inspection.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? tokenVal = await storage.read(key: "token");

            if (!widget.isEditing!) {
              var inspectionId = await InspectionApiService()
                  .addInspection(tokenVal, inspection, widget.carId);
              if (files.isNotEmpty) {
                await CarApiService()
                    .uploadFiles(tokenVal, files, inspectionId);
              }
            } else {
              await InspectionApiService().updateInspection(
                  tokenVal, inspection, widget.editModel!.idPrzegladu);
            }

            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        CarItem(carId: widget.carId),
                  ),
                  ModalRoute.withName('/dashboard'));
              // Navigator.pop(context);
            });
          }
        },
        backgroundColor: mainColor,
        label:
            Text(widget.isEditing! ? ("Zapisz przegląd") : ("Dodaj przegląd")),
        icon: Icon(Icons.check),
      ),
    );
  }
}
