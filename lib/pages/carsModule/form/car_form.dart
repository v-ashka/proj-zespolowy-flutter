import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/date_picker.dart';
import 'package:projzespoloey/utils/photo_picker.dart';

class CarForm extends StatefulWidget {
  final bool isEditing;
  final String? carId;
  final String? brand;
  final String? make;

  const CarForm(
      {Key? key, this.isEditing = false, this.carId, this.brand, this.make})
      : super(key: key);

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  List brandList = [];
  List modelList = [];
  List transmissionList = [];
  List fuelTypeList = [];
  List drivetrainList = [];
  int? fuelType;
  int? transmissionType;
  int? drivetrainType;
  String? brandItem;
  int? modelItem;
  int prodDate = DateTime.now().year;
  String? imgId = "";
  CarModelForm carItem = CarModelForm();
  final _formKey = GlobalKey<FormState>();
  File? image;
  int? transmission;
  String? token;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(token));
    fuelTypeList = (await CarApiService().getFuelTypes(token));
    transmissionList = (await CarApiService().getTransmissionTypes(token));
    drivetrainList = (await CarApiService().getDrivetrainTypes(token));
    if (widget.isEditing) {
      carItem = await CarApiService().getCarFormData(token, widget.carId);
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  void yearPicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: bgSmokedWhite,
              onSurface: Colors.black,
            )),
            child: AlertDialog(
              title: const Text("Wybierz rok produkcji"),
              content: SizedBox(
                width: 100,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960),
                  lastDate: DateTime(DateTime.now().year),
                  selectedDate: DateTime(prodDate),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      prodDate = dateTime.year;
                      carItem.rokProdukcji = prodDate.toString();
                    });
                    Navigator.pop(context);
                  }))
            ));
      },
    );
  }

  void showAddCarLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Zapisuję pojazd...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing
              ? (HeaderTitleType.formEditCar)
              : (HeaderTitleType.formAddCar)),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                          strokeWidth: 5,
                        ),
                        heightFactor: 15,
                      )
                    : Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Column(
                            // padding: EdgeInsets.only(bottom: 10),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    flex: 12,
                                    child: Text(
                                      "Wprowadź dane samochodu",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                    child: Text(
                                      "Marka samochodu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  if (!widget.isEditing) ...[
                                    DropdownButtonFormField(
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Wybierz markę pojazdu!';
                                          }
                                          return null;
                                        },
                                        value: brandItem,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            modelList = [];
                                            brandItem = value.toString();
                                            for (int i = 0;
                                                i < brandList.length;
                                                i++) {
                                              if (brandList[i]["nazwa"] ==
                                                  value) {
                                                modelList =
                                                    brandList[i]["modeleMarki"];
                                              }
                                            }
                                            modelItem = null;
                                          });
                                        },
                                        items: brandList.map((brand) {
                                          return DropdownMenuItem(
                                              value: brand['nazwa'],
                                              child: Text(brand['nazwa']));
                                        }).toList(),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.directions_car_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Wybierz markę",
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )))
                                  ] else ...[
                                    TextFormField(
                                      readOnly: true,
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.directions_car_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: widget.brand,
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ]
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                    child: Text(
                                      "Model samochodu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  if (!widget.isEditing) ...[
                                    DropdownButtonFormField(
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Wybierz model pojazdu!';
                                          }
                                          return null;
                                        },
                                        value: modelItem,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            modelItem = value as int?;
                                            carItem.idModelu = modelItem!;
                                          });
                                        },
                                        items: modelList.map((model) {
                                          return DropdownMenuItem(
                                              value: model['id'],
                                              child: Text(model['nazwa']));
                                        }).toList(),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.car_crash_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Wybierz model",
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )))
                                  ] else ...[
                                    TextFormField(
                                      readOnly: true,
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.car_crash_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: widget.make,
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ]
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Text(
                                            "Rok produkcji",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: () => yearPicker(context),
                                            cursorColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                    Icons.event_outlined,
                                                    color: Colors.black),
                                                contentPadding:
                                                    const EdgeInsets.all(15),
                                                hintText:
                                                    carItem.rokProdukcji != null
                                                        ? carItem.rokProdukcji
                                                            .toString()
                                                        : "Wybierz rok",
                                                hintStyle:
                                                    carItem.rokProdukcji !=
                                                            null
                                                        ? const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black)
                                                        : const TextStyle(
                                                            fontSize: 14),
                                                fillColor: bg35Grey,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                          "Data zakupu",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: TextFormField(
                                          initialValue: carItem.dataZakupu,
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? date =
                                                await datePicker(context);
                                            setState(() {
                                              carItem.dataZakupu =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(date!);
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons
                                                      .event_available_outlined,
                                                  color: Colors.black),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              hintText: carItem.dataZakupu ??
                                                  "Wybierz datę",
                                              hintStyle:
                                                  const TextStyle(fontSize: 14),
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
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
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Numer VIN",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                      initialValue: carItem.numerVin,
                                      onSaved: (String? value) {
                                        carItem.numerVin = value;
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(17)
                                      ],
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.numbers,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Podaj numer VIN",
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste';
                                        }
                                        if (value.length != 17) {
                                          return 'Numer VIN musi składać się z 17 znaków! ';
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Pojemność silnika i numer rejestracyjny",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                            initialValue: carItem
                                                .pojemnoscSilnika,
                                            onSaved: (String? value) {
                                              carItem.pojemnoscSilnika = value;
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            cursorColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 1, 20, 1),
                                                prefixIcon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1),
                                                  child: Icon(
                                                    Icons.abc,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                hintText: carItem
                                                            .pojemnoscSilnika !=
                                                        null
                                                    ? carItem.pojemnoscSilnika
                                                        .toString()
                                                    : "Pojemność silnika",
                                                hintStyle:
                                                    carItem.pojemnoscSilnika !=
                                                            null
                                                        ? const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black)
                                                        : const TextStyle(
                                                            fontSize: 14),
                                                suffixText: "cm3",
                                                suffixStyle: const TextStyle(
                                                    fontSize: 14),
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
                                              onSaved: (String? value) {
                                                carItem.numerRejestracyjny =
                                                    value;
                                              },
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              initialValue:
                                                  carItem.numerRejestracyjny,
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  prefixIcon: const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .format_list_numbered_rounded,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: "Numer rej.",
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Rodzaj paliwa i typ skrzyni biegów",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownButtonFormField(
                                            value: carItem.idRodzajuPaliwa,
                                            isExpanded: true,
                                            onChanged: (value) {
                                              setState(() {
                                                carItem.idRodzajuPaliwa =
                                                    value as int;
                                              });
                                            },
                                            items: fuelTypeList.map((fuels) {
                                              return DropdownMenuItem(
                                                  value: fuels['id'],
                                                  child: Text(
                                                    fuels['nazwa'],
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ));
                                            }).toList(),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 15, 0),
                                                prefixIcon: const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .local_gas_station_outlined,
                                                      color: fontBlack,
                                                    )),
                                                hintText: "Rodzaj paliwa",
                                                hintStyle: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                                fillColor: bg35Grey,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                )))
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
                                          DropdownButtonFormField(
                                              value: carItem
                                                  .idRodzajuSkrzyniBiegow,
                                              isExpanded: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  carItem.idRodzajuSkrzyniBiegow =
                                                      value as int;
                                                });
                                              },
                                              items: transmissionList
                                                  .map((transmission) {
                                                return DropdownMenuItem(
                                                    value: transmission['id'],
                                                    child: Text(
                                                      transmission['nazwa'],
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ));
                                              }).toList(),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 15, 0),
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 10, 10, 10),
                                                    child: Image.asset(
                                                      "assets/ico/manual-transmission.png",
                                                      width: 5,
                                                      height: 5,
                                                    ),
                                                  ),
                                                  hintText: "Typ skrzyni",
                                                  hintStyle: const TextStyle(
                                                      fontSize: 11),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Moc i rodzaj napędu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                            initialValue: carItem.moc,
                                            onSaved: (String? value) {
                                              carItem.moc = value;
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            cursorColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 1, 20, 1),
                                                prefixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 15, 5, 15),
                                                  child: Image.asset(
                                                    "assets/ico/car-engine.png",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                hintText: "Moc",
                                                suffixText: "KM",
                                                hintStyle: const TextStyle(
                                                    fontSize: 12),
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
                                          DropdownButtonFormField(
                                              value: carItem.idRodzajuNapedu,
                                              isExpanded: true,
                                              onChanged: (value) {
                                                setState(() {
                                                  carItem.idRodzajuNapedu =
                                                      value as int;
                                                });
                                              },
                                              items: drivetrainList
                                                  .map((drivetrain) {
                                                return DropdownMenuItem(
                                                    value: drivetrain['id'],
                                                    child: Text(
                                                      drivetrain['nazwa'],
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ));
                                              }).toList(),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 20, 0),
                                                  prefixIcon: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 15, 5, 15),
                                                    child: Image.asset(
                                                      "assets/ico/all-wheel-drive.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                  hintText: "Napęd",
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Przebieg pojazdu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                      initialValue: carItem.przebieg,
                                      onSaved: (String? value) {
                                        carItem.przebieg = value;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 1, 20, 1),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 15, 5, 15),
                                            child: Image.asset(
                                              "assets/ico/counter.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                          hintText: "Przebieg pojazdu",
                                          suffixText: "km",
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste';
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (!widget.isEditing) ...[
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 10),
                                            child: Text("Zdjęcie pojazdu"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: secondaryColor,
                                              padding: image != null
                                                  ? const EdgeInsets.all(0)
                                                  : const EdgeInsets.all(35),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25))),
                                            onPressed: () async {
                                              image = await pickImage();
                                              setState(() {
                                                image;
                                              });
                                            },
                                            child: image != null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(25),
                                                      color: secondaryColor,
                                                      image: DecorationImage(
                                                        image: FileImage(image!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : const Icon(Icons.add_a_photo_outlined, 
                                                size: 25,
                                                color: Colors.black)),
                                        ] else ...[
                                          const SizedBox(height: 25),
                                          if (image == null) ...[
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: secondColor,
                                                  foregroundColor:
                                                      bgSmokedWhite,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                onPressed: () async {
                                                  image = await pickImage();
                                                  setState(() {
                                                    image;
                                                  });
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.image_outlined),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        "Zmień zdjęcie pojazdu",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))
                                                  ],
                                                ))
                                          ] else ...[
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: secondaryColor,
                                                  padding: image != null
                                                      ? const EdgeInsets.all(0)
                                                      : const EdgeInsets.all(
                                                          35),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25))),
                                                onPressed: () async {
                                                  image = await pickImage();
                                                  setState(() {
                                                    image;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    color: secondaryColor,
                                                    image: DecorationImage(
                                                      image: FileImage(image!),
                                                      fit: BoxFit.cover
                                                    ),
                                                  ),
                                                  width: 100,
                                                  height: 100
                                                ))
                                          ]
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: isLoadingBtn ? (const SizedBox.shrink())
          : Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30), 
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      isLoadingBtn = true;
                      carItem.rokProdukcji ??= DateTime.now().year.toString();
                      carItem.dataZakupu ??= DateTime.now().toString().substring(0, 10);
                    });
                    showAddCarLoadingDialog(true);
                    if (!widget.isEditing) {
                      var response = await CarApiService().addCar(token, carItem);
                      if (image != null) {
                        await FilesService().uploadFile(token, image!.path.toString(), response.body);
                      }
                    } else {
                      await CarApiService().updateCar(token, carItem, widget.carId);
                      if (image != null) {
                        await FilesService().uploadFile(token, image!.path.toString(), widget.carId);
                      }
                    }
                    setState(() {
                      showAddCarLoadingDialog(false);
                    });
                  }
                },
                backgroundColor: mainColor,
                label: Text(
                    widget.isEditing ? ("Zapisz pojazd") : ("Dodaj pojazd")),
                icon: const Icon(Icons.check),
              ),
            ),
    );
  }
}
