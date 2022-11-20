import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/appbar.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:http/http.dart' as http;
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/form/car_form.dart';
import 'package:projzespoloey/utils/delete_dialog.dart';
import 'package:projzespoloey/utils/http_delete.dart';

import '../../constants.dart';

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  List<CarListView>? carList;
  String? token;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    carList = (await CarApiService().getCars(token));
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
    // data = ModalRoute.of(context)?.settings.arguments as UserDataArguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(context, HeaderTitleType.carList),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Center(
              child: carList == null
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: mainColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: carList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final carItem = carList![index];
                          if (carList!.isEmpty) {
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
                                          CarItem(carId: carItem.idSamochodu),
                                    ));
                              },
                              onLongPress: () {
                                HapticFeedback.heavyImpact();
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
                                              "Chcesz usunąć lub edytować ten pojazd?"),
                                          content: const Text(
                                              "Wybierz jedną z opcji dostępnych poniżej."),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: mainColor,
                                                  onPrimary: mainColor,
                                                  shape: RoundedRectangleBorder(
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
                                                          CarForm(
                                                              carId: carItem
                                                                  .idSamochodu,
                                                              isEditing: true,
                                                              brand:
                                                                  carItem.marka,
                                                              make: carItem
                                                                  .model),
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
                                                Navigator.of(context).pop();
                                                showDeleteDialog(true);
                                                bool response =
                                                    await deleteRecord(
                                                        Endpoints.carDefault,
                                                        token,
                                                        carItem.idSamochodu);
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
                                            child: Text(
                                                "${carItem.marka} ${carItem.model}",
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
                                                const Text("OKRES WAŻNOŚCI",
                                                    style: TextStyle(
                                                        color: fontGrey,
                                                        fontFamily: "Roboto",
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        letterSpacing: 1.2)),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: bg35Grey),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 20, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .text_snippet_outlined,
                                                            color: icon70Black),
                                                        Text(
                                                          carItem.koniecOC !=
                                                                  null
                                                              ? "${carItem.koniecOC} dni"
                                                              : "Brak",
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Lato",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
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
                                                          BorderRadius.circular(
                                                              25),
                                                      color: bg35Grey),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 0, 20, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .car_repair_outlined,
                                                            color: icon70Black),
                                                        Text(
                                                          carItem.koniecPrzegladu !=
                                                                  null
                                                              ? "${carItem.koniecPrzegladu} dni"
                                                              : "Brak",
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Lato",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
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
                                                    getPhoto(
                                                        carItem.idSamochodu),
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
          Navigator.pushNamed(
            context,
            "/carForm",
          ).then((value) {});
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
