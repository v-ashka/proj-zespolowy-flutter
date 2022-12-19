import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:projzespoloey/components/files_button.dart';
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
    setState(() {});
  }

  Future refreshData() async {
    setState(() {
      repairList = [];
    });
    await getData();
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
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: refreshData,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                        collapsed: DetailBar(
                                            title: "Data naprawy",
                                            value: repair.dataNaprawy!),
                                        expanded: Column(children: [
                                          DetailBar(
                                              title: "Data naprawy",
                                              value: repair.dataNaprawy!),
                                          if (repair.warsztat != null &&
                                              repair.warsztat != "")
                                            DetailBar(
                                                title: "Warsztat",
                                                value: repair.warsztat!),
                                          if (repair.kosztNaprawy != null)
                                            DetailBar(
                                                title: "Koszt naprawy",
                                                value: repair.kosztNaprawy
                                                    .toString()),
                                          if (repair.przebieg != null)
                                            DetailBar(
                                                title: "Przebieg",
                                                value:
                                                    repair.przebieg.toString()),
                                          if (repair.dataNastepnejWymiany !=
                                                  null ||
                                              repair.liczbaKilometrowDoNastepnejWymiany !=
                                                  null)
                                            DetailBar(
                                                title: "Następna wymiana",
                                                value: repair.dataNastepnejWymiany !=
                                                            null &&
                                                        repair.liczbaKilometrowDoNastepnejWymiany ==
                                                            null
                                                    ? "${repair.dataNastepnejWymiany}"
                                                    : repair.dataNastepnejWymiany ==
                                                                null &&
                                                            repair.liczbaKilometrowDoNastepnejWymiany !=
                                                                null
                                                        ? "${repair.liczbaKilometrowDoNastepnejWymiany}"
                                                        : "${repair.dataNastepnejWymiany} lub po ${repair.liczbaKilometrowDoNastepnejWymiany} km"),
                                          if (repair.opis != null &&
                                              repair.opis != "")
                                            DetailBar(
                                                title: "Opis",
                                                value: repair.opis!),
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
                                                    DeleteButton(
                                                        endpoint:
                                                            Endpoints.carRepair,
                                                        token: token,
                                                        id: repair.idNaprawy,
                                                        callback: getData,
                                                        dialogtype:
                                                            AlertDialogType
                                                                .repair),
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
                                                                carId: widget
                                                                    .car
                                                                    .idSamochodu!,
                                                                editModel:
                                                                    repair,
                                                                isEditing: true,
                                                              ),
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
                                                          color: mainColor,
                                                        ),
                                                        child: Icon(
                                                          Icons.edit_outlined,
                                                          size: 30,
                                                          color: bgSmokedWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    FilesButton(
                                                        objectId:
                                                            repair!.idNaprawy!)
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
                  }),
            )),
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
