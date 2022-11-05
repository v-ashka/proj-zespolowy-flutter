import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/emptyBox.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/inspection_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/form/inspection_form.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';

class CarServiceView extends StatefulWidget {
  const CarServiceView({Key? key}) : super(key: key);

  @override
  State<CarServiceView> createState() => _CarServiceViewState();
}

class _CarServiceViewState extends State<CarServiceView> {
  Map item = {};
  InspectionModel? inspectionData = InspectionModel();
  String? token;
  @override
  void initState() {
    super.initState();
     Future.delayed(Duration.zero, () {
      setState(() {
        item = item.isNotEmpty
            ? item
            : ModalRoute.of(context)?.settings.arguments as Map;
      });
      _getData(item["car"]["idSamochodu"]);
    });
  }

   _getData(id) async {
    token = await storage.read(key: "token");
    inspectionData = (await InspectionApiService().getInspection(token, id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(inspectionData == null)
    {
      return const LoadingScreen();
    }
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();

    print("test: ${item}");
    print("service data is: ");
    print(inspectionData!.toJson());
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: Colors.transparent,
            shadowColor: Colors.transparent,
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
            fontSize: MediaQuery.of(context).textScaleFactor * 18,
            color: Colors.black),
        title:
            Text("Przegląd - ${item["car"]["marka"]} ${item["car"]["model"]}"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView(children: [
              CarImageContainer(
                  image: item["car"]["idSamochodu"],
                  brand: item["car"]["marka"],
                  model: item["car"]["model"],
                  prodDate: item["car"]["rokProdukcji"],
                  engine: item["car"]["pojemnoscSilnika"],
                  vinNr: item["car"]["numerVin"],
                  carRegNumber: item["car"]["numerRejestracyjny"]),
              SizedBox(
                height: 15,
              ),
              if (item["car"]["koniecPrzegladu"] == null) ...[
                EmptyBoxInfo(
                    title: "Dodaj przegląd w kilku krokach",
                    description:
                        "Aktualnie nie dodałeś jeszcze żadnego przeglądu zrób to już teraz klikając w to powiadomienie!",
                    addRouteLink: {
                      "routeName": "/formCarService",
                      "arguments": {
                        "form_type": "car_insurance",
                        'idSamochodu': item["car"]["idSamochodu"],
                      }
                    })
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Aktualny Przegląd",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "DANE DOTYCZĄCE PRZEGLĄDU",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: fontGrey,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.text_snippet_outlined,
                                        size: 82,
                                        color: bg50Grey,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Stacja diagnostyczna:  ",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: secondaryColor),
                                            child: Text(
                                                "${inspectionData?.nazwaStacjiDiagnostycznej}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Numer badania:  ",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: secondaryColor),
                                            child: Text(
                                                "${inspectionData?.numerBadania}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Wynik badania pojazdu:  ",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color:
                                                    inspectionData?.czyPozytywny ==
                                                            true
                                                        ? (secondaryColor)
                                                        : (errorColor)),
                                            child: Text(
                                              inspectionData?.czyPozytywny == true
                                                  ? ("Pozytywny")
                                                  : ("Negatywny"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Okres przeglądu:  ",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: secondaryColor),
                                            child: Text(
                                                "${inspectionData?.dataPrzegladu} / ${inspectionData?.koniecWaznosciPrzegladu}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        textDirection: TextDirection.ltr,
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: [
                                          Text(
                                            "Dodatkowe informacje:  ",
                                            style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: secondaryColor),
                                            child: Text(inspectionData?.uwagi ?? "Brak dodatkowych informacji",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: fontBlack)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          "OKRES WAŻNOŚCI PRZEGLĄDU",
                          style: TextStyle(
                              fontSize: 12,
                              color: fontGrey,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 80,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: secondaryColor),
                                child: Text(
                                    "${item["car"]["koniecPrzegladu"].toString()} dni",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: fontBlack)),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(5),
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  onPrimary: deleteBtn,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )),
                              onPressed: () {
                                print("delete object");
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        child: AlertDialog(
                                          actionsPadding: EdgeInsets.all(0),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          title: Text(
                                              "Czy na pewno chcesz usunąć ten element?"),
                                          content: Text(
                                              "Po usunięciu nie możesz cofnąć tej akcji."),
                                          actions: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor,
                                                    onPrimary: mainColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    )),
                                                onPressed: () {
                                                  print("no");
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Anuluj",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: deleteBtn,
                                                    onPrimary: deleteBtn,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    )),
                                                onPressed: () async {
                                                  print("yes");
                                                  // insuranceData.IdUbezpieczenia
                                                  print(
                                                      "token is ${storage.read(key: "token")}");
                                                  print(
                                                      "service id is: $inspectionData.idPrzegladu");
                                                  String? tokenVal =
                                                      await storage.read(
                                                          key: "token");

                                                  final deleteRequest =
                                                      await InspectionApiService()
                                                          .deleteInspection(
                                                              tokenVal,
                                                              inspectionData
                                                                  ?.idPrzegladu);
                                                  setState(() {
                                                    if (deleteRequest)
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute<
                                                                  void>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CarItem(
                                                                        carId: item["car"]
                                                                            [
                                                                            "idSamochodu"]!),
                                                              ),
                                                              ModalRoute.withName(
                                                                  "/dashboard"));
                                                  });
                                                },
                                                child: Text(
                                                  "Usuń",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: deleteBtn,
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 30,
                                  color: bgSmokedWhite,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(5),
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  onPrimary: mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )),
                              onPressed: () {
                                print("edit object");
                                // Navigator.pushAndRemoveUntil(
                                //     context,
                                //     MaterialPageRoute<void>(
                                //       builder: (BuildContext context) =>
                                //           ServiceForm(
                                //               editRecord: true,
                                //               service: inspectionData,
                                //               carId: item["car"]
                                //                   ["idSamochodu"]!),
                                //     ),
                                //     ModalRoute.withName("/dashboard"));
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: mainColor,
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 30,
                                  color: bgSmokedWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    print("historia ubezpieczenie");
                    Navigator.pushNamed(context, "/carServiceHistory",
                        arguments: {"data": item["data"]});
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
                                "Historia Przeglądów",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: fontBlack,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "ZARCHIWIOZWANE PRZEGLĄDY",
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
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.analytics_outlined,
                                        size: 20,
                                        color: fontGrey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "10",
                                        style: TextStyle(
                                          color: fontBlack,
                                        ),
                                      )
                                    ],
                                  ),
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
                  height: 50,
                ),
              ]
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/formCarService",
              arguments: {'idSamochodu': item["car"]["idSamochodu"]});
        },
        backgroundColor: mainColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
