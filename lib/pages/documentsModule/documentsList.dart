import 'package:expandable/expandable.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:chip_list/chip_list.dart';
import 'package:projzespoloey/components/search_bar.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/pages/loading.dart';
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
  List<DocumentModel> documentList = [];
  List<DocumentModel> filteredList = [];
  List<DocumentModel> initialList = [];
  DocumentModel document = DocumentModel();
  bool isGetDataFinished = false;
  List documentCategories = [];
  List<String> categoryList = [];
  int currentCategory = 0;
  String query = "";

  void getData() async {
    token = await storage.read(key: "token");
    documentList = await DocumentService().getDocumentList(token);
    filteredList = documentList;
    initialList = filteredList;
    documentCategories = (await DocumentService().getCategories(token));
    categoryList =
        documentCategories.map((e) => e["nazwa"].toString()).toList();
    categoryList.insert(0, "Wszystkie");
    String? categoryName =
        documentCategories.firstWhere((element) => element["id"] == 1)["nazwa"];
    setState(() {
      isGetDataFinished = true;
    });
  }

  void searchDocument(String filter) {
    final result = initialList.where((document) {
      final documentName = document.nazwaDokumentu!.toLowerCase();
      final input = filter.toLowerCase();
      return documentName.contains(input);
    }).toList();
    setState(() {
      query = filter;
      filteredList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!isGetDataFinished) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.documentList),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Column(
            children: <Widget>[
              SearchBar(
                  text: query,
                  onChanged: searchDocument,
                  hintText: "Wyszukaj dokument"),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
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
                    setState(() {
                      if (currentCategory == 0) {
                        filteredList = documentList;
                      } else {
                        filteredList = initialList = documentList
                            .where((e) => e.kategoria == currentCategory)
                            .toList();
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
                  itemCount: filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    document = filteredList[index];
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
                                                  "${documentCategories.firstWhere((element) => element["id"] == document.kategoria)["nazwa"]}",
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
                                                  "${document.dataUtworzenia}",
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
                                            title: "Kategoria dokumentu",
                                            value:
                                                "${documentCategories.firstWhere((element) => element["id"] == document.kategoria)["nazwa"]}"),
                                        //if (repair.warsztat != null &&
                                        //repair.warsztat != "")
                                        DetailBar(
                                            title: "Data utworzenia",
                                            value:
                                                "${document.dataUtworzenia}"),
                                        //if (repair.kosztNaprawy != null)
                                        if (document.ubezpieczyciel != null)
                                          DetailBar(
                                              title: "Ubezpieczyciel",
                                              value:
                                                  "${document.ubezpieczyciel}"),
                                        if (document.sprzedawcaNaFakturze !=
                                            null)
                                          DetailBar(
                                              title: "Sprzedawca",
                                              value:
                                                  "${document.sprzedawcaNaFakturze}"),
                                        if (document.dataWystawieniaFaktury !=
                                            null)
                                          DetailBar(
                                              title: "Faktura z dnia",
                                              value:
                                                  "${document.dataWystawieniaFaktury}"),
                                        if (document.numerFaktury != null)
                                          DetailBar(
                                              title: "Numer faktury",
                                              value:
                                                  "${document.numerFaktury}"),

                                        if (document.wartoscPolisy != null)
                                          DetailBar(
                                              title: "Koszt polisy",
                                              value:
                                                  "${document.wartoscPolisy}"),
                                        if (document.wartoscFaktury != null)
                                          DetailBar(
                                              title: "Kwota na fakturze",
                                              value:
                                                  "${document.wartoscFaktury}"),
                                        if (document.dataStartu != null &&
                                            document.dataKonca != null)
                                          DetailBar(
                                              title: "Okres obowiązywania",
                                              value:
                                                  "${document.dataStartu} / ${document.dataStartu}"),
                                        if (document.dataPrzypomnienia != null)
                                          DetailBar(
                                              title: "Data przypomnienia",
                                              value:
                                                  "${document.dataPrzypomnienia}"),
                                        if (document.opis != null &&
                                            document.opis != "")
                                          DetailBar(
                                              title: "Opis",
                                              value: "${document.opis}"),
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
                                                          Endpoints.document,
                                                      token: token,
                                                      id: document.idDokumentu,
                                                      callback: getData,
                                                      dialogtype:
                                                          AlertDialogType
                                                              .document),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            foregroundColor:
                                                                mainColor,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    5),
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
                                                      child: const Icon(
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
            "/documentForm",
          ).then((value) {});
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
