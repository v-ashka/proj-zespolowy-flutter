import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/inspection_model.dart';
import 'package:projzespoloey/pages/carsModule/filesView.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';

class InspectionHistory extends StatefulWidget {
  final String carId;
  final String carModel;
  const InspectionHistory(
      {Key? key, required this.carId, required this.carModel})
      : super(key: key);

  @override
  State<InspectionHistory> createState() => _InspectionHistoryState();
}

class _InspectionHistoryState extends State<InspectionHistory> {
  String? token;
  List<InspectionModel> inspectionList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    inspectionList =
        await InspectionApiService().getInspectionList(token, widget.carId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          child: const Icon(
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
        title: Text("Historia przeglądów - ${widget.carModel}"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.transparent,
                    ),
                itemCount: inspectionList.length,
                itemBuilder: (BuildContext context, int index) {
                  final inspection = inspectionList[index];
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                child: Text(
                                                  "Przegląd techniczny",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20),
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
                                            const Text(
                                              "Okres ważności:  ",
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
                                                    const EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: secondaryColor),
                                                child: Text(
                                                    "${inspection.dataPrzegladu} / ${inspection.koniecWaznosciPrzegladu}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: fontBlack)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      expanded: Column(
                                        children: [
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${inspection.nazwaStacjiDiagnostycznej}",
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${inspection.numerBadania}",
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: inspection
                                                                    .czyPozytywny ==
                                                                true
                                                            ? (secondaryColor)
                                                            : (errorColor)),
                                                    child: Text(
                                                      inspection.czyPozytywny ==
                                                              true
                                                          ? ("Pozytywny")
                                                          : ("Negatywny"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor),
                                                    child: Text(
                                                        "${inspection.dataPrzegladu} / ${inspection.koniecWaznosciPrzegladu}",
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
                                          if (inspection.uwagi != null)
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
                                                    "Dodatkowe informacje:  ",
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
                                                        "${inspection.uwagi}",
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              primary: Colors
                                                                  .transparent,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              onPrimary:
                                                                  deleteBtn,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              )),
                                                      onPressed: () {
                                                        print("delete object");
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child:
                                                                    AlertDialog(
                                                                  actionsPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  actionsAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
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
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                            )),
                                                                        onPressed: () {
                                                                          print(
                                                                              "no");
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                          "Anuluj",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: deleteBtn,
                                                                            onPrimary: deleteBtn,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                            )),
                                                                        onPressed: () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Response
                                                                              response =
                                                                              await InspectionApiService().deleteInspection(token, inspection!.idPrzegladu);
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            setState(() {
                                                                              getData();
                                                                            });
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                          "Usuń",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        )),
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          color: deleteBtn,
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .delete_outline_rounded,
                                                          size: 30,
                                                          color: bgSmokedWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
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
                                                        print("file list");
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FilesView(
                                                                      objectId:
                                                                          inspection
                                                                              .idPrzegladu!),
                                                            ));
                                                      },
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
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
                                        ],
                                      ),
                                    ),
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
    );
  }
}
