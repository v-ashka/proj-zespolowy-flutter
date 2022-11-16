import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/car_repair_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/filesView.dart';
import 'package:projzespoloey/pages/carsModule/form/car_repair_edit_form.dart';
import 'package:projzespoloey/pages/carsModule/form/car_repair_form.dart';
import 'package:projzespoloey/services/car/car_repair_history_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';

class CarRepairHistoryView extends StatefulWidget {
  final CarModel car;
  const CarRepairHistoryView({Key? key, required this.car}) : super(key: key);

  @override
  State<CarRepairHistoryView> createState() => _CarRepairHistoryViewState();
}

class _CarRepairHistoryViewState extends State<CarRepairHistoryView> {
  String? token;
  List<CarRepairModel> repairList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    token = await storage.read(key: "token");
    repairList = await CarRepairHistoryService()
        .getRepairList(token, widget.car.idSamochodu);
    setState(() {
      print("WYKONUJE FUNKCJE NA ZEWNATRZ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.carRepair, "-",
          widget.car.marka, widget.car.model),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.transparent,
                    ),
                itemCount: repairList.length,
                itemBuilder: (BuildContext context, int index) {
                  final repair = repairList[index];
                  return Container(
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
                                                "${repair.nazwaNaprawy}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 10),
                                                child: Text(
                                                  "DANE DOTYCZĄCE USŁUGI",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: fontGrey,
                                                      fontFamily: "Roboto",
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      collapsed: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Data naprawy:  ",
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
                                                        BorderRadius.circular(
                                                            25),
                                                    color: secondaryColor),
                                                child: Text(
                                                    "${repair.dataNaprawy}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      expanded: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Data naprawy:  ",
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
                                                          BorderRadius.circular(
                                                              25),
                                                      color: secondaryColor),
                                                  child: Text(
                                                      "${repair.dataNaprawy}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (repair.warsztat != null &&
                                            repair.warsztat != "")
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Warsztat:  ",
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${repair.warsztat}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (repair.kosztNaprawy != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: [
                                                  Text(
                                                    "Koszt naprawy:  ",
                                                    style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${repair.kosztNaprawy} zł",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: fontBlack)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (repair.przebieg != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: [
                                                  Text(
                                                    "Przebieg:  ",
                                                    style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${repair.przebieg} km",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: fontBlack)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (repair.dataNastepnejWymiany !=
                                                null ||
                                            repair.liczbaKilometrowDoNastepnejWymiany !=
                                                null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: [
                                                  Text(
                                                    "Następna wymiana:  ",
                                                    style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: repair.dataNastepnejWymiany != null &&
                                                            repair.liczbaKilometrowDoNastepnejWymiany ==
                                                                null
                                                        ? Text("${repair.dataNastepnejWymiany}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    fontBlack))
                                                        : repair.dataNastepnejWymiany == null &&
                                                                repair.liczbaKilometrowDoNastepnejWymiany !=
                                                                    null
                                                            ? Text("${repair.liczbaKilometrowDoNastepnejWymiany}",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        fontBlack))
                                                            : Text("${repair.dataNastepnejWymiany} lub po ${repair.liczbaKilometrowDoNastepnejWymiany} km",
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fontBlack)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (repair.opis != null &&
                                            repair.opis != "")
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                spacing: 5,
                                                runSpacing: 5,
                                                children: [
                                                  Text(
                                                    "Opis:  ",
                                                    style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${repair.opis}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: fontBlack)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DeleteButton(
                                                      endpoint:
                                                          Endpoints.carRepair,
                                                      token: token,
                                                      id: repair.idNaprawy,
                                                      callback: getData,
                                                      dialogtype:
                                                          AlertDialogType
                                                              .carRepair),
                                                  // DeleteButton(
                                                  //     responseType:
                                                  //         CarRepairHistoryService()
                                                  //             .deleteRepair(
                                                  //                 token,
                                                  //                 repair
                                                  //                     .idNaprawy),
                                                  //     refreshData: getData(),
                                                  //     dialogtype:
                                                  //         AlertDialogType
                                                  //             .carRepair),
                                                  // ElevatedButton(
                                                  //   style: ElevatedButton
                                                  //       .styleFrom(
                                                  //           padding:
                                                  //               EdgeInsets.all(
                                                  //                   5),
                                                  //           primary: Colors
                                                  //               .transparent,
                                                  //           shadowColor: Colors
                                                  //               .transparent,
                                                  //           onPrimary:
                                                  //               deleteBtn,
                                                  //           shape:
                                                  //               RoundedRectangleBorder(
                                                  //             borderRadius:
                                                  //                 BorderRadius
                                                  //                     .circular(
                                                  //                         100),
                                                  //           )),
                                                  //   onPressed: () {
                                                  //     showDialog(
                                                  //         context: context,
                                                  //         builder: (BuildContext
                                                  //             context) {
                                                  //           return Container(
                                                  //             padding:
                                                  //                 EdgeInsets
                                                  //                     .all(5),
                                                  //             child:
                                                  //                 AlertDialog(
                                                  //               actionsPadding:
                                                  //                   EdgeInsets
                                                  //                       .all(0),
                                                  //               actionsAlignment:
                                                  //                   MainAxisAlignment
                                                  //                       .center,
                                                  //               shape:
                                                  //                   RoundedRectangleBorder(
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(
                                                  //                             25),
                                                  //               ),
                                                  //               title: Text(
                                                  //                   "Czy na pewno chcesz usunąć ten element?"),
                                                  //               content: Text(
                                                  //                   "Po usunięciu nie możesz cofnąć tej akcji."),
                                                  //               actions: [
                                                  //                 ElevatedButton(
                                                  //                     style: ElevatedButton.styleFrom(
                                                  //                         primary: mainColor,
                                                  //                         onPrimary: mainColor,
                                                  //                         shape: RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius.circular(25),
                                                  //                         )),
                                                  //                     onPressed: () {
                                                  //                       print(
                                                  //                           "no");
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                     },
                                                  //                     child: Text(
                                                  //                       "Anuluj",
                                                  //                       style: TextStyle(
                                                  //                           color:
                                                  //                               Colors.white),
                                                  //                     )),
                                                  //                 ElevatedButton(
                                                  //                     style: ElevatedButton.styleFrom(
                                                  //                         primary: deleteBtn,
                                                  //                         onPrimary: deleteBtn,
                                                  //                         shape: RoundedRectangleBorder(
                                                  //                           borderRadius:
                                                  //                               BorderRadius.circular(25),
                                                  //                         )),
                                                  //                     onPressed: () async {
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                       Response
                                                  //                           response =
                                                  //                           await CarRepairHistoryService().deleteRepair(token,
                                                  //                               repair.idNaprawy);
                                                  //                       if (response.statusCode ==
                                                  //                           200) {
                                                  //                         setState(
                                                  //                             () {
                                                  //                           getData();
                                                  //                         });
                                                  //                       }
                                                  //                     },
                                                  //                     child: Text(
                                                  //                       "Usuń",
                                                  //                       style: TextStyle(
                                                  //                           color:
                                                  //                               Colors.white),
                                                  //                     )),
                                                  //               ],
                                                  //             ),
                                                  //           );
                                                  //         });
                                                  //   },
                                                  //   child: Container(
                                                  //     width: 50,
                                                  //     height: 50,
                                                  //     decoration: BoxDecoration(
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(25),
                                                  //       color: deleteBtn,
                                                  //     ),
                                                  //     child: Icon(
                                                  //       Icons
                                                  //           .delete_outline_rounded,
                                                  //       size: 30,
                                                  //       color: bgSmokedWhite,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            primary: Colors
                                                                .transparent,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            onPrimary:
                                                                mainColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            )),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CarRepairForm(
                                                              carId: widget.car
                                                                  .idSamochodu!,
                                                              editModel: repair,
                                                              isEditing: true,
                                                            ),
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor: Colors
                                                                .transparent,
                                                            foregroundColor:
                                                                mainColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            )),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                FilesView(
                                                                    objectId: repair
                                                                        .idNaprawy!),
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: secondColor,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .file_open_outlined,
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CarRepairForm(carId: widget.car.idSamochodu!),
              ));
        },
        backgroundColor: mainColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
