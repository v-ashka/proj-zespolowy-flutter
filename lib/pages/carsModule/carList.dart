import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:http/http.dart' as http;
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';

import '../../constants.dart';

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  // late UserDataArguments data;

  // late List<CarListView>? _carList = [];
  // @override
  // void initState() {
  //   super.initState();
  //   _getData();
  // }

  // void _getData() async {
  //   _carList = (await CarApiService().getCars(data.token))!;
  //   setState(() {
  //   });
  // }

  var _carList = [];
  @override
  Widget build(BuildContext context) {
    // data = ModalRoute.of(context)?.settings.arguments as UserDataArguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text('Pojazdy'),
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
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        foregroundColor:
            Colors.black, //Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Center(
              child: _carList!.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                      color: mainColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        // item count carList
                        // itemCount: _carList!.length,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          if (_carList.length == 10) {
                            return Center(
                              child: Text("Trochę tu pusto..."),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context,
                                //     "/${widget.data['route_name'].toString().substring(0, widget.data['route_name'].toString().length - 1)}Item",
                                //     arguments: {
                                //       "data": _carList![index].idSamochodu,
                                //       "token": widget.data["user_auth"]
                                //     });
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
                                            child: Text("marka model",
                                                // "${_carList![index].marka} ${_carList![index].model}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("OKRES WAŻNOŚCI",
                                                    style: TextStyle(
                                                        color: fontGrey,
                                                        fontFamily: "Roboto",
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        letterSpacing: 1.2)),
                                                SizedBox(
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
                                                        Icon(
                                                            Icons
                                                                .text_snippet_outlined,
                                                            color: icon70Black),
                                                        Text(
                                                          "Koniec OC dni",
                                                          // "${_carList![index].koniecOC} dni",
                                                          style: TextStyle(
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
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: bg35Grey),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 20, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .car_repair_outlined,
                                                            color: icon70Black),
                                                        Text(
                                                          "Koniec oc dni",
                                                          // _carList?[index].koniecOC == null ?
                                                          //     "Brak":
                                                          // "${_carList![index].koniecOC} dni"
                                                          /*"${_carList![index].koniecOC} dni"*/
                                                          style: TextStyle(
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
                                    // FittedBox(child: Image.asset("assets/asterka.jpg"), fit: BoxFit.fill)
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
                                                    "zdjecie ",
                                                    // '${SERVER_IP}/api/fileUpload/GetFile/${_carList![index].idSamochodu}?naglowkowy=true',
                                                    width: 170,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                    alignment:
                                                        Alignment(-0.5, 0),
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
                                                          child: Icon(
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
        label: Text('Dodaj nowy'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
