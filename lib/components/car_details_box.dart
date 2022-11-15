import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';

class CarDetailBox extends StatelessWidget {
  final CarModel carModel;
  const CarDetailBox({Key? key, required this.carModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: bgSmokedWhite,
        boxShadow: const [
          BoxShadow(
            color: bg35Grey,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ExpandablePanel(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "Dane pojazdu",
                              style: const TextStyle(
                                  fontSize: 20, 
                                  color: fontBlack,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: Text(
                                "Kliknij, aby zobaczyć więcej informacji o pojeździe",
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
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      children: [
                        DetailBar(title: "Numer VIN", value: carModel.numerVin!),
                        DetailBar(title: "Pojemność silnika", value: "${carModel.pojemnoscSilnika!.toString()} cm3"),
                        DetailBar(title: "Rodzaj paliwa", value: carModel.rodzajPaliwa!),
                        DetailBar(title: "Skrzynia biegów", value: carModel.rodzajSkrzyniBiegow!),
                        DetailBar(title: "Moc", value: "${carModel.moc.toString()} KM"),
                        DetailBar(title: "Napęd", value: carModel.rodzajNapedu!),
                        DetailBar(title: "Data zakupu", value: carModel.dataZakupu!)
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(
                        //       15, 15, 5, 0),
                        //   child: Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment
                        //             .spaceBetween,
                        //     children: [
                        //       const SizedBox(
                        //         width: 20,
                        //       ),
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.start,
                        //         crossAxisAlignment:
                        //             CrossAxisAlignment.start,
                        //         children: [
                        //           ElevatedButton(
                        //             style: ElevatedButton
                        //                 .styleFrom(
                        //                     padding:
                        //                         EdgeInsets
                        //                             .all(5),
                        //                     primary: Colors
                        //                         .transparent,
                        //                     shadowColor: Colors
                        //                         .transparent,
                        //                     onPrimary:
                        //                         deleteBtn,
                        //                     shape:
                        //                         RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius
                        //                               .circular(
                        //                                   100),
                        //                     )),
                        //             onPressed: () {
                        //               print("delete object");
                        //               showDialog(
                        //                   context: context,
                        //                   builder:
                        //                       (BuildContext
                        //                           context) {
                        //                     return Container(
                        //                       padding:
                        //                           EdgeInsets
                        //                               .all(5),
                        //                       child:
                        //                           AlertDialog(
                        //                         actionsPadding:
                        //                             EdgeInsets
                        //                                 .all(
                        //                                     0),
                        //                         actionsAlignment:
                        //                             MainAxisAlignment
                        //                                 .center,
                        //                         shape:
                        //                             RoundedRectangleBorder(
                        //                           borderRadius:
                        //                               BorderRadius.circular(
                        //                                   25),
                        //                         ),
                        //                         title: Text(
                        //                             "Czy na pewno chcesz usunąć ten element?"),
                        //                         content: Text(
                        //                             "Po usunięciu nie możesz cofnąć tej akcji."),
                        //                         actions: [
                        //                           ElevatedButton(
                        //                               style: ElevatedButton.styleFrom(
                        //                                   primary: mainColor,
                        //                                   onPrimary: mainColor,
                        //                                   shape: RoundedRectangleBorder(
                        //                                     borderRadius: BorderRadius.circular(25),
                        //                                   )),
                        //                               onPressed: () {
                        //                                 print(
                        //                                     "no");
                        //                                 Navigator.of(context)
                        //                                     .pop();
                        //                               },
                        //                               child: Text(
                        //                                 "Anuluj",
                        //                                 style:
                        //                                     TextStyle(color: Colors.white),
                        //                               )),
                        //                           ElevatedButton(
                        //                               style: ElevatedButton.styleFrom(
                        //                                   primary: deleteBtn,
                        //                                   onPrimary: deleteBtn,
                        //                                   shape: RoundedRectangleBorder(
                        //                                     borderRadius: BorderRadius.circular(25),
                        //                                   )),
                        //                               onPressed: () async {
                        //                                 Navigator.of(context)
                        //                                     .pop();
                        //                                 Response
                        //                                     response =
                        //                                     await InspectionApiService().deleteInspection(token, inspection!.idPrzegladu);
                        //                                 if (response.statusCode ==
                        //                                     200) {
                        //                                   setState(() {
                        //                                     getData();
                        //                                   });
                        //                                 }
                        //                               },
                        //                               child: Text(
                        //                                 "Usuń",
                        //                                 style:
                        //                                     TextStyle(color: Colors.white),
                        //                               )),
                        //                         ],
                        //                       ),
                        //                     );
                        //                   });
                        //             },
                        //             child: Container(
                        //               width: 50,
                        //               height: 50,
                        //               decoration:
                        //                   BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius
                        //                         .circular(25),
                        //                 color: deleteBtn,
                        //               ),
                        //               child: Icon(
                        //                 Icons
                        //                     .delete_outline_rounded,
                        //                 size: 30,
                        //                 color: bgSmokedWhite,
                        //               ),
                        //             ),
                        //           ),
                        //           ElevatedButton(
                        //             style: ElevatedButton
                        //                 .styleFrom(
                        //                     padding:
                        //                         EdgeInsets
                        //                             .all(5),
                        //                     backgroundColor:
                        //                         Colors
                        //                             .transparent,
                        //                     shadowColor: Colors
                        //                         .transparent,
                        //                     foregroundColor:
                        //                         mainColor,
                        //                     shape:
                        //                         RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius
                        //                               .circular(
                        //                                   100),
                        //                     )),
                        //             onPressed: () {
                        //               print("file list");
                        //               Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         FilesView(
                        //                             objectId:
                        //                                 inspection
                        //                                     .idPrzegladu!),
                        //                   ));
                        //             },
                        //             child: Container(
                        //               width: 50,
                        //               height: 50,
                        //               decoration:
                        //                   BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius
                        //                         .circular(50),
                        //                 color: secondColor,
                        //               ),
                        //               child: Icon(
                        //                 Icons
                        //                     .file_open_outlined,
                        //                 size: 30,
                        //                 color: bgSmokedWhite,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
