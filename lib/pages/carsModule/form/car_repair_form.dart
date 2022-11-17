import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/car_repair_model.dart';
import 'package:projzespoloey/models/inspection_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/services/car/car_repair_history_service.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/date_picker.dart';

class CarRepairForm extends StatefulWidget {
  final String carId;
  final bool? isEditing;
  final CarRepairModel? editModel;
  const CarRepairForm(
      {Key? key, required this.carId, this.isEditing = false, this.editModel})
      : super(key: key);

  @override
  State<CarRepairForm> createState() => _CarRepairFormState();
}

class _CarRepairFormState extends State<CarRepairForm> {
  final _formKey = GlobalKey<FormState>();
  CarRepairModel carRepair = CarRepairModel(
      dataNaprawy: DateFormat('dd.MM.yyyy').format(DateTime.now()));
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    checkIfEditForm(widget.isEditing, widget.editModel);
  }

  void checkIfEditForm(isEdit, editModel) async {
    if (isEdit) {
      carRepair = editModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing!
              ? (HeaderTitleType.formEditRepair)
              : (HeaderTitleType.carRepair)),
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
                                "Wprowadź szczegóły naprawy",
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
                                "Nazwa przeprowadzonej naprawy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                initialValue: carRepair.nazwaNaprawy ?? "",
                                onSaved: (String? value) {
                                  carRepair.nazwaNaprawy = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons
                                            .drive_file_rename_outline_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Nazwa naprawy",
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Nazwa warsztatu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: carRepair.warsztat ?? "",
                              onSaved: (String? value) {
                                carRepair.warsztat = value;
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
                                  hintText: "Nazwa warsztatu",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
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
                                      "Data wykonania naprawy",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Przebieg pojazdu",
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
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? date =
                                                await pickDate(context);
                                            setState(() {
                                              carRepair.dataNaprawy =
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(date!);
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: carRepair.dataNaprawy ??
                                                  "Data naprawy",
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
                                            // if (date == null ||
                                            //     date.isEmpty) {
                                            //   return 'To pole nie może być puste';
                                            // }
                                            // return null;
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
                                          initialValue: widget.isEditing! &&
                                                  carRepair.przebieg != null
                                              ? (carRepair.przebieg.toString())
                                              : (""),
                                          onSaved: (String? value) {
                                            carRepair.przebieg =
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Koszt naprawy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: widget.isEditing! &&
                                      carRepair.przebieg != null
                                  ? (carRepair.przebieg.toString())
                                  : (""),
                              onSaved: (String? value) {
                                carRepair.kosztNaprawy = double.parse(value!);
                              },
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp("[,]"))
                              ],
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.attach_money_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Koszt naprawy",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
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
                                      "Data następnej naprawy",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Kolejna naprawa za",
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
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                              await pickDate(context);
                                          setState(() {
                                            carRepair.dataNastepnejWymiany =
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
                                                Icons.calendar_month_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: carRepair
                                                    .dataNastepnejWymiany ??
                                                "Data następnej naprawy",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                      ),
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
                                          initialValue: widget.isEditing! &&
                                                  carRepair
                                                          .liczbaKilometrowDoNastepnejWymiany !=
                                                      null
                                              ? (carRepair
                                                  .liczbaKilometrowDoNastepnejWymiany
                                                  .toString())
                                              : (""),
                                          onSaved: (String? value) {
                                            carRepair
                                                    .liczbaKilometrowDoNastepnejWymiany =
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
                                                  Icons.add_road_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Liczba kilometrów",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          // validator: (value) {
                                          //   if (value == null ||
                                          //       value.isEmpty) {
                                          //     return 'To pole nie może być puste';
                                          //   }
                                          //   return null;
                                          // }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Text(
                                "Opis naprawy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextFormField(
                                initialValue: carRepair.opis ?? "",
                                maxLines: 4,
                                onSaved: (String? value) {
                                  carRepair.opis = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    hintText: "Dodaj opis naprawy...",
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
                        if (!widget.isEditing!)
                          AddAttachmentButton(
                              files: files, formType: FormType.carRepair)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(carRepair.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? token = await storage.read(key: "token");
            if (!widget.isEditing!) {
              Response response = await CarRepairHistoryService()
                  .addRepair(token, carRepair, widget.carId);
              if (files.isNotEmpty && response.statusCode == 200 ||
                  response.statusCode == 202) {
                await FilesService().uploadFiles(token, files, response.body);
              }
              response.statusCode == 200 || response.statusCode == 202
                  ? setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CarItem(carId: widget.carId),
                          ),
                          ModalRoute.withName('/dashboard'));
                      // Navigator.pop(context);
                    })
                  : print("BŁĄD PRZESYŁANIA DANYCH");
            } else {
              Response res = await CarRepairHistoryService()
                  .updateRepair(token, carRepair, carRepair.idNaprawy);
              print(res.statusCode);
              print(res.reasonPhrase);
              res.statusCode == 200 || res.statusCode == 202
                  ? setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CarItem(carId: widget.carId),
                          ),
                          ModalRoute.withName('/dashboard'));
                      // Navigator.pop(context);
                    })
                  : print("BŁĄD PRZESYŁANIA DANYCH");
            }
          }
        },
        backgroundColor: mainColor,
        label: Text(widget.isEditing! ? ("Zapisz naprawę") : ("Dodaj naprawę")),
        icon: Icon(Icons.check),
      ),
    );
  }
}
