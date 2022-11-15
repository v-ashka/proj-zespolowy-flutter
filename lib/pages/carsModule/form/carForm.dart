import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/utils/photo_picker.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

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
  CarModelForm carItem = CarModelForm(
      RokProdukcji: DateTime.now().year,
      DataZakupu: DateTime.now().toString().substring(0, 10));
  final _formKey = GlobalKey<FormState>();
  File? image;

  @override
  void initState() {
    super.initState();
    _getModeleMarki();
  }

  void _getModeleMarki() async {
    String? tokenVal = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(tokenVal));
    fuelTypeList = (await CarApiService().getFuelTypes(tokenVal));
    transmissionList = (await CarApiService().getTransmissionTypes(tokenVal));
    drivetrainList = (await CarApiService().getDrivetrainTypes(tokenVal));
    setState(() {
      isLoading = !isLoading;
    });
  }

  void handleReadOnlyInputClick(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: mainColor, // header background color
              onPrimary: bgSmokedWhite, // header text color
              onSurface: Colors.black, // body text color
            )),
            child: AlertDialog(
              title: Text("Wybierz rok produkcji"),
              content: Container(
                width: 100,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960),
                  lastDate: DateTime(DateTime.now().year),
                  selectedDate: DateTime(prodDate),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      prodDate = dateTime.year;
                      carItem.RokProdukcji = prodDate;
                      print("${prodDate}");
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
      },
    );
  }

  void showAddCarLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: const Text('Dodaję pojazd...'),
              content: Container(
                  height: 150,
                  width: 150,
                  child: const Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CarList(),
          ),
          ModalRoute.withName("/dashboard"));
    }
  }

  Future<DateTime?> pickDate(context) {
    var date = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2026),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: myAppBar(context, HeaderTitleType.formAddCar),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
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
                      ? Center(
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
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
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
                                            ))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 5),
                                      child: Text(
                                        "Model samochodu",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
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
                                            carItem.IdModelu = modelItem!;
                                            print(modelItem);
                                          });
                                        },
                                        items: modelList.map((model) {
                                          return DropdownMenuItem(
                                              value: model['id'],
                                              child: Text(model['nazwa']));
                                        }).toList(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
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
                                            ))),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 5),
                                            child: Text(
                                              "Rok produkcji",
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width/2.4,
                                            child: TextFormField(
                                              readOnly: true,
                                              onTap: () =>
                                                  handleReadOnlyInputClick(
                                                      context),
                                              cursorColor: Colors.black,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.event_outlined, color: Colors.black),
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  hintText: carItem.RokProdukcji
                                                      .toString(),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 14),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                              /*validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste';
                                        }
                                        return null;
                                      }*/
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 5),
                                          child: Text(
                                            "Data zakupu",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width/2.4,
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? date =
                                                  await pickDate(context);
                                              setState(() {
                                                carItem.DataZakupu =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(date!);
                                              });
                                            },
                                            cursorColor: Colors.black,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(Icons.event_available_outlined, color: Colors.black),
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                hintText: carItem.DataZakupu,
                                                hintStyle: const TextStyle(
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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Numer VIN",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                        onSaved: (String? value) {
                                          carItem.NumerVin = value;
                                        },
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(17)
                                        ],
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                              onSaved: (String? value) {
                                                carItem.PojemnoscSilnika =
                                                    int.parse(value!);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 1, 20, 1),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons.abc,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: "Pojemność silnika",
                                                  suffixText: "cm3",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
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
                                                  carItem.NumerRejestracyjny =
                                                      value;
                                                },
                                                textCapitalization: TextCapitalization.characters,
                                                cursorColor: Colors.black,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1),
                                                      child: Icon(
                                                        Icons
                                                            .format_list_numbered_rounded,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    hintText: "Numer rej.",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    fillColor: bg35Grey,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          BorderSide.none,
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ));
                                              }).toList(),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 15, 0),
                                                  prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1),
                                                      child: Icon(
                                                        Icons
                                                            .local_gas_station_outlined,
                                                        color: fontBlack,
                                                      )),
                                                  hintText: "Rodzaj paliwa",
                                                  hintStyle: TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
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
                                                        style: TextStyle(
                                                            fontSize: 11),
                                                      ));
                                                }).toList(),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 15, 0),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 10, 10, 10),
                                                      child: Image.asset(
                                                        "assets/ico/manual-transmission.png",
                                                        width: 5,
                                                        height: 5,
                                                      ),
                                                    ),
                                                    hintText: "Typ skrzyni",
                                                    hintStyle:
                                                        TextStyle(fontSize: 11),
                                                    fillColor: bg35Grey,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          BorderSide.none,
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                              onSaved: (String? value) {
                                                carItem.Moc = int.parse(value!);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 1, 20, 1),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 15, 5, 15),
                                                    child: Image.asset(
                                                      "assets/ico/car-engine.png",
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                  hintText: "Moc",
                                                  suffixText: "KM",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
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
                                                        style: TextStyle(
                                                            fontSize: 11),
                                                      ));
                                                }).toList(),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 20, 0),
                                                    prefixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 15, 5, 15),
                                                      child: Image.asset(
                                                        "assets/ico/all-wheel-drive.png",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ),
                                                    hintText: "Napęd",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    fillColor: bg35Grey,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          BorderSide.none,
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Przebieg pojazdu",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                        onSaved: (String? value) {
                                          carItem.Przebieg = int.parse(value!);
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10, 1, 20, 1),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 5, 15),
                                              child: Image.asset(
                                                "assets/ico/counter.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            hintText: "Przebieg pojazdu",
                                            suffixText: "km",
                                            hintStyle: TextStyle(fontSize: 12),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                            onPressed: () async {
                                              image = await pickImage();
                                              setState(() {
                                                image;
                                              });
                                            },
                                            child: image != null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: secondaryColor,
                                                      image: DecorationImage(
                                                        image:
                                                            FileImage(image!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : const Icon(
                                                    Icons.add_a_photo_outlined,
                                                    size: 25,
                                                    color: Colors.black),
                                          ),
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
        floatingActionButton: isLoadingBtn
            ? (SizedBox.shrink())
            : Padding(
                padding: MediaQuery.of(context).viewInsets.bottom != 0
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 30)
                    : EdgeInsets.zero,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        isLoadingBtn = true;
                      });
                      showAddCarLoadingDialog(true);
                      String? tokenVal = await storage.read(key: "token");
                      var id = await CarApiService().addCar(tokenVal, carItem);
                      var uploadImg = await CarApiService().uploadFile(
                          tokenVal, image!.path.toString(), id.body);
                      setState(() {
                        showAddCarLoadingDialog(false);
                      });
                    }
                  },
                  backgroundColor: mainColor,
                  label: const Text("Zapisz pojazd"),
                  icon: const Icon(Icons.check),
                ),
              ),
        bottomSheet: MediaQuery.of(context).viewInsets.bottom > 150
            ? GestureDetector(
                onTap: () => print("CIPSKO"),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: bg35Grey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 10),
                        Text(
                          "Zeskanuj",
                          style: TextStyle(
                              fontFamily: 'Lato', fontWeight: FontWeight.w600),
                        )
                      ],
                    )),
              )
            : const SizedBox.shrink());
  }
}
