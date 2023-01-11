import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/components/delete_button.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/files_button.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/inspection_model.dart';
import 'package:organizerPRO/services/inspection_service.dart';
import 'package:organizerPRO/utils/http_delete.dart';

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
      appBar: myAppBar(context, HeaderTitleType.carInsepctionHistory),
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
                                            children: const [
                                              Padding(
                                                padding:
                                                     EdgeInsets.fromLTRB(
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
                                      collapsed: DetailBar(
                                          title: "Okres ważności",
                                          value:
                                              "${inspection.dataPrzegladu} / ${inspection.koniecWaznosciPrzegladu}"),
                                      expanded: Column(
                                        children: [
                                          DetailBar(
                                              title: "Stacja diagnostyczna",
                                              value:
                                                  "${inspection.nazwaStacjiDiagnostycznej}"),
                                          DetailBar(
                                              title: "Numer badania",
                                              value:
                                                  "${inspection.numerBadania}"),
                                          DetailBar(
                                              title: "Wynik badania pojazdu",
                                              value: inspection.czyPozytywny ==
                                                      true
                                                  ? ("Pozytywny")
                                                  : ("Negatywny")),
                                          DetailBar(
                                              title: "Okres ważności",
                                              value:
                                                  "${inspection.dataPrzegladu} / ${inspection.koniecWaznosciPrzegladu}"),
                                          if (inspection.uwagi != null)
                                            DetailBar(
                                                title: "Dodatkowe informacje",
                                                value: "${inspection.uwagi}"),
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
                                                        endpoint: Endpoints
                                                            .carInspection,
                                                        token: token,
                                                        id: inspection
                                                            .idPrzegladu,
                                                        dialogtype:
                                                            AlertDialogType
                                                                .carInspection,
                                                        callback: getData),
                                                    FilesButton(
                                                        objectId: inspection
                                                            .idPrzegladu!)
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
