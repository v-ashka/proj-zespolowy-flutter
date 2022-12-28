import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:projzespoloey/components/appbar.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:projzespoloey/components/search_bar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/receipts/receipt_list_model.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptItem.dart';
import 'package:projzespoloey/pages/receiptsModule/receipt_form.dart';
import 'package:projzespoloey/services/receipt/receipt_api_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';
import 'package:chip_list/chip_list.dart';

class ReceiptList extends StatefulWidget {
  const ReceiptList({Key? key}) : super(key: key);

  @override
  State<ReceiptList> createState() => ReceiptListState();
}

class ReceiptListState extends State<ReceiptList> {
  List<ReceiptListView> receiptList = [];
  List<ReceiptListView> filteredList = [];
  List<ReceiptListView> initialList = [];
  List documentCategories = [];
  List<String> categoryList = [];
  String? token;
  bool isGetDataFinished = false;
  String query = "";
  int currentCategory = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Future<void> getData() async {
  //   token = await storage.read(key: "token");
  //   receiptList = (await ReceiptApiService().getReceipts(token));
  //   setState(() {});
  // }

  Future<void> getData() async {
    token = await storage.read(key: "token");
    receiptList = (await ReceiptApiService().getReceipts(token));
    filteredList = receiptList;
    initialList = filteredList;
    documentCategories = (await ReceiptApiService().getCategories(token));
    categoryList =
        documentCategories.map((e) => e["nazwa"].toString()).toList();
    categoryList.insert(0, "Wszystkie");
    String? categoryName =
    documentCategories.firstWhere((element) => element["id"] == 1)["nazwa"];
    setState(() {
      isGetDataFinished = true;
    });
  }

  Future refreshData() async {
    setState(() {
      receiptList = [];
    });
    await getData();
  }

  String getPhoto(receiptId) {
    return "$SERVER_IP/api/fileUpload/GetFile/$receiptId?naglowkowy=true";
  }

  void showDeleteDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void searchReceipt(String filter) {
    final result = initialList.where((receipt) {
      final receiptName = receipt.nazwa!.toLowerCase();
      final input = filter.toLowerCase();
      return receiptName.contains(input);
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
      appBar:
          myAppBar(context, HeaderTitleType.receipt),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              SearchBar(
                  text: query,
                  onChanged: searchReceipt,
                  hintText: "Wyszukaj paragon"),
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
                        filteredList = receiptList;
                      } else {
                        filteredList = initialList = receiptList
                            .where((e) => e.idKategorii == currentCategory)
                            .toList();
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: RefreshIndicator(
                    color: mainColor,
                    onRefresh: refreshData,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final receiptItem = filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReceiptItem(
                                      receiptId: receiptItem.idParagonu!,
                                    ),
                                  ));
                            },
                            onLongPress: () {
                              HapticFeedback.vibrate();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(5),
                                      child: AlertDialog(
                                        actionsPadding:
                                            const EdgeInsets.all(0),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        title: const Text(
                                            "Chcesz usunąć lub edytować ten paragon?"),
                                        content: const Text(
                                            "Wybierz jedną z opcji dostępnych poniżej."),
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
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReceiptForm(
                                                      receiptId: receiptItem
                                                          .idParagonu,
                                                      isEditing: true,
                                                    ),
                                                  ));
                                            },
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " Edytuj",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Lato',
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: deleteBtn,
                                                backgroundColor: deleteBtn,
                                                shape:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25),
                                                )),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              showDeleteDialog(true);
                                              bool response =
                                                  await deleteRecord(
                                                      Endpoints
                                                          .receiptDefault,
                                                      token,
                                                      receiptItem
                                                          .idParagonu);
                                              if (response) {
                                                showDeleteDialog(false);
                                                getData();
                                              }
                                            },
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons
                                                          .delete_outline_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " Usuń",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Lato',
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                              height: 130,
                              width: 150,
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 10, 0, 0),
                                          child: Text(
                                              "${receiptItem.nazwa}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                              overflow:
                                                  TextOverflow.ellipsis),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                  "PODSTAWOWE INFORMACJE",
                                                  style: TextStyle(
                                                      color: fontGrey,
                                                      fontFamily: "Roboto",
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 1.2)),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 5, 0, 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    const Text(
                                                        "Okres zwrotu:"),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25),
                                                          color:
                                                              secondaryColor),
                                                      child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  15),
                                                          child: Text(
                                                            "${receiptItem.koniecZwrotu} dni",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Lato",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 5, 0, 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    const Text(
                                                        "Okres gwarancji:"),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25),
                                                          color:
                                                              secondaryColor),
                                                      child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  15),
                                                          child: Text(
                                                            "${receiptItem.koniecGwarancji} dni",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Lato",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(0, 5, 0, 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                  children: [
                                                    const Text("Cena:"),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25),
                                                          color:
                                                              secondaryColor),
                                                      child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  15),
                                                          child: Text(
                                                            "${receiptItem.cena} zł",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Lato",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: SizedBox(
                                      width: 200,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            left: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 100, 200, 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25),
                                                color: main25Color,
                                              ),
                                              width: 90,
                                              height: 150,
                                            ),
                                          ),
                                          Positioned.fill(
                                              right: 0,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(25),
                                                    color: main50Color,
                                                  ),
                                                  width: 190,
                                                  height: 150,
                                                ),
                                              )),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25),
                                                child: Image.network(
                                                  getPhoto(receiptItem
                                                      .idParagonu),
                                                  width: 130,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  alignment:
                                                      const Alignment(0, 0),
                                                  errorBuilder:
                                                      (BuildContext context,
                                                          Object exception,
                                                          StackTrace?
                                                              stackTrace) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    25),
                                                        child: const Icon(
                                                          Icons
                                                              .not_interested_rounded,
                                                          size: 88,
                                                          color: errorColor,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
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
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/receiptForm",
          ).then((value) {});
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
