import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/components/car_details_box.dart';
import 'package:projzespoloey/components/car_image_container.dart';
import 'package:projzespoloey/constants.dart';
import 'package:animations/animations.dart';
import 'package:projzespoloey/main.dart';
import 'package:projzespoloey/models/inspection_model.dart';
import 'package:projzespoloey/models/insurace_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/car_insurance_view.dart';
import 'package:projzespoloey/pages/carsModule/car_repair_history_view.dart';
import 'package:projzespoloey/pages/carsModule/inspection_view.dart';
import 'package:projzespoloey/pages/old_/dashboard.dart';
import 'package:projzespoloey/pages/form.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';
import 'package:projzespoloey/services/car/insurance_service.dart';

import '../../components/appbar.dart';

class CarItem extends StatefulWidget {
  String carId;
  CarItem({Key? key, required this.carId}) : super(key: key);

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  late CarModel? carModel = CarModel();
  late InsuranceModel insuranceData = InsuranceModel();
  late InspectionModel? inspectionData = InspectionModel();
  String? token;
  String carId = "";
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    _getData(widget.carId);
  }

  _getData(id) async {
    token = await storage.read(key: "token");
    carModel = (await CarApiService().getCarTest(token, id));
    insuranceData = (await getValidOC(token, id));
    inspectionData = (await InspectionApiService().getInspection(token, id));
    setState(() {isGetDataFinished = true;});
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetDataFinished) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.carDefault, "-",
          carModel?.marka, carModel?.model),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: carModel?.idSamochodu == null
              ? ((Center(
                  child: CircularProgressIndicator(
                  color: mainColor,
                ))))
              : (ListView(
                  children: [
                    CarImageContainer(
                        image: carModel!.idSamochodu!,
                        brand: carModel!.marka!,
                        model: carModel!.model!,
                        prodYear: carModel!.rokProdukcji!,
                        carRegNumber: carModel!.numerRejestracyjny!),
                    SizedBox(
                      height: 15,
                    ),
                    CarDetailBox(carModel: carModel!, context: context, token: token!),
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
                        // Navigator.pushNamed(context, "/carInsurance",
                        //     arguments: {
                        //       "car": carModel,
                        //       "data": insuranceData.idUbezpieczenia != null
                        //           ? (insuranceData)
                        //           : (null)
                        //     });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarInsuranceView(
                                car: carModel!,
                              ),
                            ));
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
                                  if (insuranceData.idUbezpieczenia !=
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
                                            carModel!.koniecOC != null
                                                ? "${carModel!.koniecOC} dni"
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
                                            carModel!.koniecAC != null
                                                ? "${carModel!.koniecAC} dni"
                                                : "brak",
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            "W tym miejscu pojawi się okres ważności ubezpieczenia OC oraz AC.",
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarServiceView(
                                car: carModel!,
                              ),
                            ));
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
                                  if (carModel!.koniecPrzegladu != null) ...[
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
                                            carModel!.koniecPrzegladu != null
                                                ? "${carModel!.koniecPrzegladu} dni"
                                                : "Brak",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nie dodałeś jeszcze żadnego przeglądu!",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Po dodaniu dokumentu, w tym miejscu zobaczysz okres jego ważności.",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CarRepairHistoryView(car: carModel!),
                            ));
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
                                  const Text(
                                    "Historia Napraw",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  if (carModel!.ostatniaNaprawa != null) ...[
                                    const Text(
                                      "OSTATNIA NAPRAWA",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: fontGrey,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(
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
                                            "${carModel!.ostatniaNaprawa} dni temu",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nie dodałeś jeszcze żadnej naprawy!",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "W tym miejscu zobaczysz ilość dni, które upłynęły od ostatniej naprawy.",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
    );
  }
}
