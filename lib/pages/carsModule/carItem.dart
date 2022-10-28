import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';
import 'package:animations/animations.dart';
import 'package:projzespoloey/main.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/dashboard.dart';
import 'package:projzespoloey/pages/form.dart';

class CarItem extends StatefulWidget {
  String carId;
  CarItem({Key? key, required this.carId}) : super(key: key);

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  late Map<String, dynamic>? carData = {};

  late InsuranceFormModel insuranceData = InsuranceFormModel();
  late List? serviceData = [];
  final storage = new FlutterSecureStorage();
  String carId = "";

  @override
  void initState() {
    super.initState();
    _getData(widget.carId);
  }

  void _getData(id) async {
    String? tokenVal = await storage.read(key: "token");

    carData = (await CarApiService().getCar(tokenVal, id));
    insuranceData = (await CarApiService().getValidInsurance(tokenVal, id));
    serviceData = (await CarApiService().getService(tokenVal, id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();

    // print("item: ");
    // print(item);
    // print("car data");
    // print(carData!.length);
    // print("test token: ${storage.read(key: "token")}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: secondaryColor,
            //onPrimary: Colors.transparent,
            //shadowColor: Colors.red,
            onSurface: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.transparent,
        backgroundColor: secondaryColor,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
        title: Text(carData!.length == 0
            ? ("Ładuję...")
            : ("Pojazd - ${carData!["marka"]} ${carData!["model"]}  ")),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: carData!.length == 0
              ? ((Center(
                  child: CircularProgressIndicator(
                  color: mainColor,
                ))))
              : (ListView(
                  children: [
                    CarImageContainer(
                        image: carData!["idSamochodu"],
                        brand: carData!["marka"],
                        model: carData!["model"],
                        prodDate: carData!["rokProdukcji"],
                        engine: carData!["pojemnoscSilnika"],
                        vinNr: carData!["numerVin"],
                        carRegNumber: carData!["numerRejestracyjny"]),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: bgSmokedWhite,
                          onPrimary: bg35Grey,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      onPressed: () {
                        // print("ubezpieczenie");
                        Navigator.pushNamed(context, "/carInsurance",
                            arguments: {
                              "car": carData,
                              "data": insuranceData.IdUbezpieczenia != null
                                  ? (insuranceData)
                                  : (null)
                            });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ubezpieczenie",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  if (insuranceData.IdUbezpieczenia !=
                                      null) ...[
                                    Text(
                                      "OKRES WAŻNOŚCI",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: fontGrey,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 100,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "OC",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            carData?["koniecOC"] != null
                                                ? "${carData!["koniecOC"].toString()} dni"
                                                : "brak",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 100,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "AC",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            insuranceData == null ||
                                                    insuranceData
                                                            .IdRodzajuUbezpieczenia !=
                                                        2
                                                ? ("brak")
                                                : ("WPISAC DNI"),
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ] else ...[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nie dodałeś jeszcze żadnego ubezpieczenia!",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "W tym miejscu pojawi się okres ważności ubezpieczenia OC oraz AC",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                              Icon(
                                Icons.text_snippet_outlined,
                                size: 82,
                                color: bg50Grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: bgSmokedWhite,
                          onPrimary: bg35Grey,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      onPressed: () {
                        // print("przeglad");
                        Navigator.pushNamed(context, "/carService", arguments: {
                          "car": carData,
                          "data": serviceData,
                          "id": widget.carId,
                        });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Przegląd",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "OKRES WAŻNOŚCI PRZEGLĄDU",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fontGrey,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 100,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.car_repair_outlined,
                                          size: 20,
                                          color: fontGrey,
                                        ),
                                        Text(
                                          serviceData!.length > 1
                                              ? ("ERROR")
                                              //("${CarApiService().daysBetween(CarApiService().today, DateTime.parse(serviceData!["dataNastepnegoPrzegladu"]))} dni")
                                              : ("brak"),
                                          style: TextStyle(
                                            color: fontBlack,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.history_outlined,
                                size: 82,
                                color: bg50Grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: bgSmokedWhite,
                          onPrimary: bg35Grey,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      onPressed: () {
                        // print("naprawy");
                        Navigator.pushNamed(context, "/carRepairHistory",
                            arguments: {
                              "id": widget.carId,
                              "car": carData,
                              "data": serviceData
                            });
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Historia Napraw",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "OSTATNIE NAPRAWY",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fontGrey,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.build_outlined,
                                          size: 20,
                                          color: fontGrey,
                                        ),
                                        Text(
                                          "320 dni temu",
                                          style: TextStyle(
                                            color: fontBlack,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.manage_history_outlined,
                                size: 82,
                                color: bg50Grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                )),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/form",
              arguments: {'form_type': 'add_car'});
        },
        backgroundColor: mainColor,
        label: Text('Dodaj nowy'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
