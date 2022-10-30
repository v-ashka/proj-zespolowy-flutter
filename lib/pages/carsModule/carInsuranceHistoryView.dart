import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/components/emptyBox.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceEditForm.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';

class CarInsuranceHistoryView extends StatefulWidget {
  const CarInsuranceHistoryView({Key? key}) : super(key: key);

  @override
  State<CarInsuranceHistoryView> createState() =>
      _CarInsuranceHistoryViewState();
}

class _CarInsuranceHistoryViewState extends State<CarInsuranceHistoryView> {
  Map item = {};

 Widget build(BuildContext context) {
  item = item.isNotEmpty
            ? item
            : ModalRoute.of(context)?.settings.arguments as Map;
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();
    if(item.isEmpty){
      return const LoadingScreen();
    }
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
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
        title: Text("Ubezpieczenie - ${item["car"]["model"]}"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView(children: [
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
                                  ExpandablePanel(
                                  header: Row(
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
                                            "Polisa OC",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "DANE DOTYCZĄCE POLISY",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: fontGrey,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                    
                                    ],
                                  ),
                                  collapsed: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Okres ubezpieczenia:  ",
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
                                                "2022-01-01  / 2022-01-01",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: fontBlack)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  expanded: Column(
                                    children: [
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
                                          "Numer polisy:  ",
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
                                              "2022/01/FGHGF/212",
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
                                          "Nazwa firmy ubezpieczeniowej:  ",
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
                                                "PZU",
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
                                          "Okres ubezpieczenia:  ",
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
                                                "2022-01-01  / 2022-01-01",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: fontBlack)),
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
                                          "Składka OC:  ",
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
                                                "1011 zł",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: fontBlack)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(5),
                                      primary: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      onPrimary: deleteBtn,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: mainColor,
                                                            onPrimary:
                                                                mainColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            )),
                                                    onPressed: () {
                                                      print("no");
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Anuluj",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: deleteBtn,
                                                            onPrimary:
                                                                deleteBtn,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            )),
                                                    onPressed: () async {
                                                      // print("yes");
                                                      // // insuranceData.IdUbezpieczenia
                                                      // tokenVal = await storage
                                                      //     .read(key: "token");
                                                      // var deleteRes =
                                                      //     await CarApiService()
                                                      //         .deleteInsurance(
                                                      //             tokenVal,
                                                      //             insuranceData
                                                      //                 .IdUbezpieczenia);
                                                      // setState(() {
                                                      //   if (deleteRes)
                                                      //     Navigator
                                                      //         .pushReplacement(
                                                      //             context,
                                                      //             MaterialPageRoute<
                                                      //                 void>(
                                                      //               builder: (BuildContext
                                                      //                       context) =>
                                                      //                   CarItem(carId: idSamochodu),
                                                      //             ));
                                                      // });
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                  onPressed: () {
                                    // print("edit object");
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           InsuranceEditForm(
                                    //               insurance: insuranceData,
                                    //               carId: idSamochodu),
                                    //     ));
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(5),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: mainColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                  onPressed: () {
                                    // print("file list");
                                    // Navigator.pushNamed(context, "/fileList",
                                    //     arguments: {
                                    //       "data": insuranceData,
                                    //       "form_type": "car_insurance"
                                    //     });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: secondColor,
                                    ),
                                    child: Icon(
                                      Icons.file_open_outlined,
                                      size: 30,
                                      color: bgSmokedWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ), 
                                ]),
                                
                              ),    
                                ], //TUTAJ SIE KONCZY
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              
            ])),
      ),

    );
  }
}
