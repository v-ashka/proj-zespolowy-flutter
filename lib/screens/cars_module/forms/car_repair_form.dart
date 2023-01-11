import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:organizerPRO/components/add_attachment_button.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/car_repair_model.dart';
import 'package:organizerPRO/screens/cars_module/car_item_view.dart';
import 'package:organizerPRO/services/car_repair_history_service.dart';
import 'package:organizerPRO/services/files_service.dart';
import 'package:organizerPRO/utils/date_picker.dart';

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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                          children: const[
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
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    prefixIcon: const Padding(
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
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 350,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
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
                            const SizedBox(
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
                                                await datePicker(context);
                                            setState(() {
                                              carRepair.dataNaprawy =
                                                  DateFormat('dd.MM.yyyy')
                                                      .format(date!);
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              prefixIcon: const Padding(
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
                                                  const TextStyle(fontSize: 12),
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
                                          style: const TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(1),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.edit_road_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Przebieg auta",
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
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
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp("[,]"))
                              ],
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  prefixIcon: const Padding(
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
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 350,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
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
                            const SizedBox(
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
                                              await datePicker(context);
                                          setState(() {
                                            carRepair.dataNastepnejWymiany =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(date!);
                                          });
                                        },
                                        cursorColor: Colors.black,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.calendar_month_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: carRepair
                                                    .dataNastepnejWymiany ??
                                                "Data następnej naprawy",
                                            hintStyle: const TextStyle(fontSize: 12),
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
                                          style: const TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(1),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.add_road_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Liczba kilometrów",
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
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
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
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
                              //files: files,
                              formType: FormType.repair,
                              onChanged: (filesList) {
                                files = filesList;
                              })
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
              if (response.statusCode == 200 || response.statusCode == 202){
                  setState(() {
                      Navigator.of(context).pop(CarItem(carId: widget.carId));
                      Navigator.of(context, rootNavigator: true).pop();
                    });}
            } else {
              Response res = await CarRepairHistoryService()
                  .updateRepair(token, carRepair, carRepair.idNaprawy);
              if (res.statusCode == 200 || res.statusCode == 202){
                   setState(() {
                      Navigator.of(context).pop(CarItem(carId: widget.carId));
                      Navigator.of(context, rootNavigator: true).pop();
                    });}
            }
          }
        },
        backgroundColor: mainColor,
        label: Text(widget.isEditing! ? ("Zapisz naprawę") : ("Dodaj naprawę")),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
