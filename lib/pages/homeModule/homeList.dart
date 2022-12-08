import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/appbar.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:projzespoloey/pages/homeModule/home_form.dart';
import 'package:projzespoloey/services/home/home_service.dart';
import 'package:projzespoloey/services/home_service.dart';

import '../../constants.dart';
import '../../models/home_model.dart';
import '../../utils/http_delete.dart';
import 'homeItem.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  List<HomeListView>? homeList;
  String? token;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    homeList = await HomeService().getHomeList(token);
    setState(() {});
  }

  String getPhoto(carId) {
    var url = '$SERVER_IP/api/fileUpload/GetFile/$carId?naglowkowy=true';
    return url;
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

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(context, HeaderTitleType.homeList),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Center(
              child: homeList == null
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: mainColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: homeList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final homeItem = homeList![index];
                          if (homeList!.isEmpty) {
                            return const Center(
                              child: Text("Trochę tu pusto..."),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeItem(homeId: homeItem.idDomu),
                                    ));
                              },
                              onLongPress: () {
                                SystemSound.play(SystemSoundType.alert);
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
                                              "Chcesz usunąć lub edytować ten dom?"),
                                          content: const Text(
                                              "Wybierz jedną z opcji dostępnych poniżej."),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: mainColor,
                                                  foregroundColor: mainColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  )),
                                              onPressed: () {
                                                // Navigator.pop(context);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           CarForm(
                                                //               carId: homeItem
                                                //                   .idSamochodu,
                                                //               isEditing: true,
                                                //               brand:
                                                //               homeItem.marka,
                                                //               make: homeItem
                                                //                   .model),
                                                //     ));
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
                                                            fontFamily: 'Lato',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: deleteBtn,
                                                  onPrimary: deleteBtn,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  )),
                                              onPressed: () async {
                                                // Navigator.of(context).pop();
                                                // showDeleteDialog(true);
                                                // bool response =
                                                // await deleteRecord(
                                                //     Endpoints.carDefault,
                                                //     token,
                                                //     homeItem.idSamochodu);
                                                // if (response) {
                                                //   showDeleteDialog(false);
                                                //   getData();
                                                // }
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
                                                            fontFamily: 'Lato',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 0, 0),
                                            child: Text("${homeItem.typDomu}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                            FontWeight.w300,
                                                        letterSpacing: 1.2)),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text("Adres:"),
                                                      const SizedBox(
                                                        width: 5,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Text(
                                                              "${homeItem.ulicaNrDomu}",
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
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                          "Miejscowość:"),
                                                      const SizedBox(
                                                        width: 5,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Text(
                                                              "${homeItem.miejscowosc}",
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
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
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
                                                      BorderRadius.circular(25),
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
                                                          BorderRadius.circular(
                                                              25),
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
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    getPhoto(homeItem.idDomu),
                                                    width: 170,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                    alignment: const Alignment(
                                                        -0.3, 0),
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
                                                                  .circular(25),
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
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Colors.transparent,
                        ),
                      ),
                    ))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeForm()));
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
