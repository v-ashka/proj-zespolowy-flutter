import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:projzespoloey/components/files_button.dart';
import 'package:projzespoloey/components/search_bar.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/models/home_repair_model.dart';
import 'package:projzespoloey/pages/homeModule/home_repair_form.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/services/home_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';

import '../../constants.dart';

class HomeRepairList extends StatefulWidget {
  final String homeId;

  const HomeRepairList({Key? key, required this.homeId}) : super(key: key);

  @override
  State<HomeRepairList> createState() => _HomeRepairListState();
}

class _HomeRepairListState extends State<HomeRepairList> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  String? token;
  List<HomeRepairModel> repairList = [];
  List<HomeRepairModel> filteredList = [];
  List<HomeRepairModel> initialList = [];
  HomeRepairModel repair = HomeRepairModel();
  bool isGetDataFinished = false;
  String query = "";

  void getData() async {
    token = await storage.read(key: "token");
    repairList = (await HomeService().getHomeRepairList(widget.homeId, token))!;
    filteredList = repairList;
    initialList = filteredList;
    setState(() {
      isGetDataFinished = true;
    });
  }

  void searchRepair(String filter) {
    final result = initialList.where((repair) {
      final repairName = repair.nazwaNaprawy!.toLowerCase();
      final input = filter.toLowerCase();
      return repairName.contains(input);
    }).toList();
    setState(() {
      query = filter;
      filteredList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetDataFinished) {
      return const LoadingScreen();
    }
    return Scaffold(
        appBar: myAppBar(context, HeaderTitleType.homeRepairList),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: Column(
              children: <Widget>[
                SearchBar(
                    text: query,
                    onChanged: searchRepair,
                    hintText: "Wyszukaj naprawę"),
                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 85),
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      repair = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white),
                          child: Row(
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
                                                    "SZCZEGÓŁY NAPRAWY",
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
                                        collapsed: DetailBar(title: "Data naprawy", value: repair.dataNaprawy!),
                                        expanded: Column(children: [
                                          DetailBar(
                                              title: "Data naprawy",
                                              value:
                                                  "${repair.dataNaprawy}"),
                                          if (repair.kosztNaprawy != null)
                                            DetailBar(
                                                title: "Koszt naprawy",
                                                value:
                                                    "${repair.kosztNaprawy} zł"),
                                          if (repair.opis != null && repair.opis != "")
                                            DetailBar(
                                                title: "Opis",
                                                value: "${repair.opis}"),
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
                                                            Endpoints.homeRepair,
                                                        token: token,
                                                        id: repair
                                                            .idNaprawy,
                                                        callback: getData,
                                                        dialogtype:
                                                            AlertDialogType
                                                                .repair),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  mainColor,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              shadowColor: Colors
                                                                  .transparent,
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
                                                                  HomeRepairForm(
                                                                homeId: widget.homeId,
                                                                    repair: repair,
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
                                                        child: const Icon(
                                                          Icons.edit_outlined,
                                                          size: 30,
                                                          color: bgSmokedWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    FilesButton(objectId: repair.idNaprawy!)
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
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.transparent,
                      height: 10,
                    ),
                  ),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeRepairForm(homeId: widget.homeId),
                ));
          },
          backgroundColor: secondColor,
          child: Icon(Icons.add),
        ));
  }
}
