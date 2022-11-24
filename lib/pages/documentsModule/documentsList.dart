import 'package:expandable/expandable.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:chip_list/chip_list.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';

import '../../constants.dart';

class DocumentsList extends StatefulWidget {
  const DocumentsList({Key? key}) : super(key: key);

  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  String? token;
  List<DocumentModel>? documentList;
  DocumentModel document = DocumentModel();
  bool isGetDataFinished = false;
  List documentCategories = [];
  List<String> categoryList = [];

  int currentCategory = 0;

  void getData() async {
    token = await storage.read(key: "token");
    documentList = await DocumentService().getDocumentList(token);
    documentCategories = (await DocumentService().getCategories(token));
    categoryList =
        documentCategories.map((e) => e["nazwa"].toString()).toList();
    categoryList.insert(0, "Wszystkie");
    setState(() {
      isGetDataFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.documentList),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ChipList(
                  listOfChipNames: categoryList,
                  activeBgColorList: const [secondColor],
                  inactiveBgColorList: const [Colors.white],
                  activeTextColorList: const [Colors.white],
                  inactiveTextColorList: const [Colors.black],
                  listOfChipIndicesCurrentlySeclected: [currentCategory],
                  activeBorderColorList: const [secondColor],
                  style: const TextStyle(fontSize: 13),
                  extraOnToggle: (val) {
                    currentCategory = val;
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: documentList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    document = documentList![index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10,0, 10, 0),
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
                                                "${document.nazwaDokumentu}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 10),
                                                child: Text(
                                                  "SZCZEGÓŁY DOKUMENTU",
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
                                      collapsed: Column(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              color: bg35Grey),
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 20, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                const Icon(Icons.label_outline,
                                                    color: icon70Black),
                                                Text(
                                                  "Umowa",
                                                  style: const TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                      FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              color: bg35Grey),
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 20, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              children: [
                                                const Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    color: icon70Black),
                                                Text(
                                                  "11.04.2022",
                                                  style: const TextStyle(
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                      FontWeight.w400),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                      expanded: Column(children: [
                                        DetailBar(
                                            title: "Data naprawy",
                                            value: "Data naprawy"),
                                        //if (repair.warsztat != null &&
                                        //repair.warsztat != "")
                                        DetailBar(
                                            title: "Warsztat",
                                            value: "Warsztat"),
                                        //if (repair.kosztNaprawy != null)
                                        DetailBar(
                                            title: "Koszt naprawy",
                                            value: "Koszt naprawy"),
                                        //if (repair.przebieg != null)
                                        DetailBar(
                                            title: "Przebieg",
                                            value: "Koszt naprawy"),
                                        // if (repair.dataNastepnejWymiany !=
                                        // null ||
                                        // repair.liczbaKilometrowDoNastepnejWymiany !=
                                        // null)
                                        DetailBar(
                                            title: "Następna wymiana",
                                            value: "Następna wymiana"),
                                        //if (repair.opis != null &&
                                        //repair.opis != "")
                                        DetailBar(title: "Opis", value: "Opis"),
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
                                                  // DeleteButton(
                                                  // endpoint:
                                                  // Endpoints.carRepair,
                                                  // token: token,
                                                  // id: repair.idNaprawy,
                                                  // callback: getData,
                                                  // dialogtype:
                                                  // AlertDialogType
                                                  //     .carRepair),
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
                                                      // Navigator.push(
                                                      // context,
                                                      // MaterialPageRoute(
                                                      // builder: (context) =>
                                                      // CarRepairForm(
                                                      // carId: widget.car
                                                      //     .idSamochodu!,
                                                      // editModel: repair,
                                                      // isEditing: true,
                                                      // ),
                                                      // ));
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
                                                  // FilesButton(objectId: repair!.idNaprawy!)
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/carForm",
          ).then((value) {});
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );  }
}
