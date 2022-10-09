import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projzespoloey/constants.dart';
import 'package:http/http.dart' as http;
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/old_/_carList.dart';
import 'package:collection/collection.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({Key? key, required this.data, required this.size})
      : super(key: key);

  final Map data;
  final Size size;
  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  late List<CarModel>? _carModel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  void _getData() async {
    _carModel = (await CarApiService().getCars(widget.data["user_auth"]))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          print("test value");
          print(value);
        }));

    // _carModel.add(await CarApiService()
    //     .getCarInsurance(widget.data["user_auth"], _carModel["idPubliczne"]))!;
  }

  // dynamic data;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<List> getInsurance(data, token) async {
    var carBrandListRes = await http.get(
      Uri.parse(
          '${SERVER_IP}/api/insurance/GetInsuranceList/${data["idPubliczne"]}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      },
    );
    if (carBrandListRes.statusCode == 200)
      return jsonDecode(carBrandListRes.body);
    return [];
  }

  getCars(String token) async {
    dynamic data = {};

    // dynamic datatest = {
    //   "public_id": "",
    //   "brand": "",
    //   "model": "",
    //   "img": "",
    //   "car_listview": {
    //     "service_time": "",
    //     "insurance_time": "",
    //   },
    //   "car_view": {
    //     "img_container_data": {
    //       "date_prod": "",
    //       "engine": "",
    //       "vin_nr": "",
    //       "reg_nr": "",
    //     },
    //     "insurance_box": {
    //       "oc_insurance_time": "",
    //       "ac_insurance_time": "",
    //     },
    //     "servcie_box": {
    //       "service_time": "",
    //     },
    //     "repair_history": {
    //       "last_repair_time": "",
    //       "2n_repair_time": "",
    //     }
    //   }
    // };
    var getCarListResponse = await http.get(
      Uri.parse('http://${SERVER_IP}/api/car/GetList'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      },
    );

    var carBrandListRes = await http.get(
      Uri.parse('http://${SERVER_IP}/api/car/api/MarkiModele'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${token}",
      },
    );

    // print(jsonDecode(carBrandListRes.body).runtimeType);
    // print("test: ");
    // print(carBrandList[0]);

    // print(getCarListResponse.body);

    if (getCarListResponse.statusCode == 200 &&
        carBrandListRes.statusCode == 200) {
      final tempCarListData = jsonDecode(getCarListResponse.body);
      final carBrandList = jsonDecode(carBrandListRes.body);
      data = tempCarListData;
      // data.forEach((car) async {
      //   car["car_list"] = await http.get(
      //     Uri.parse(
      //         'http://${SERVER_IP}/api/insurance/GetInsuranceList/${car["idPubliczne"]}'),
      //     headers: <String, String>{
      //       'Content-Type': 'application/json',
      //       'Authorization': "Bearer ${token}",
      //     },
      //   );
      //   car["pojemnoscSilnika"] = "abcd";
      //   // print(car["idPubliczne"]);
      //   // final tempCarInsurance = jsonDecode(carInsuranceListRes.body);
      //   // tempCarInsurance.length > 0
      //   //     ? (data[car]["car_insurance"] = "test")
      //   //     : (data[car]["car_insurance"] = "brak");
      //   data[car]["car_listview_oc_time"] = "test";

      //   // print(car);
      // });

      // data = jsonDecode(getCarListResponse.body);

      // data.forEach((item) async {
      //   // print(item["modelId"]);

      //   item["modelName"] = await carBrandList
      //       .firstWhere((expresion) => (expresion["id"] == item["modelId"]));
      //   // print(item["modelId"]["modeleMarki"][item]["id"]);
      //   // print(item["modelName"]["modeleMarki"][2]);
      //   item["modelName"]["modeleMarki"].forEach((modelItem) async {
      //     // print(modelItem);
      //     // print(item["modelId"]);
      //     if (modelItem['id'] == item["modelId"]) {
      //       item["modelName"]["modeleMarki"] = modelItem["nazwa"];
      //     } else {
      //       item["modelName"]["modeleMarki"] = modelItem["nazwa"];
      //     }
      //   });

      //   // item["modelTEST"] = await getInsurance(item, token);

      //   // itemTest.then((value) {
      //   //   print("start");
      //   //   print("test___: ${value}");
      //   //   item["testItem"] = value;
      //   //   print("end");
      //   // });
      // });

      // print("data testr: ${data[1]["idPubliczne"]}");
      // final tempModelId = data[0]["modelId"];
      // data[0]["modelId"] = carBrandList.firstWhere((item) {
      //   item["id"] == data[0]["modelId"];
      // });
      // print(data[0]["modelId"]["name"]);
      // print(data[0]["modelId"]["modeleMarki"][tempModelId]["nazwa"]);
      // return jsonDecode(getCarListResponse.body);
      print("car data: ");
      return data;
    } else {
      print("Can't fetch car list!");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data);
    // DateTime date1 = DateTime.parse(widget.data["data"][1]['end_time']);
    // print(date1);
    // // print("${widget.data["data"][0]["name"]}");
    //     return FutureBuilder(
    //     future: getCars(widget.data["user_auth"]),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: SpinKitThreeBounce(
    //             color: secondColor,
    //             size: 40,
    //           ),
    //         );
    //       } else {
    //         if (snapshot.hasError) {
    //           return Center(child: Text("Error ${snapshot.error}"));
    //         } else {
    //           return Center(child: Text("${snapshot.data}"));
    print(" ");
    print("module_list: ");
    // print(widget.data["user_auth"]);
    final today = DateTime.now();

    return Center(
        child: _carModel == null || _carModel!.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _carModel!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Text("${_carModel![index].toJson()}"),
                  );
                }));

    // return Padding(
    //   padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
    //   child: ListView.separated(
    //     padding: const EdgeInsets.all(20),
    //     // itemCount: widget.data['module_data'].length,
    //     itemCount: snapshot.data.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.pushNamed(context,
    //               "/${widget.data['route_name'].toString().substring(0, widget.data['route_name'].toString().length - 1)}Item",
    //               arguments: {
    //                 "data": snapshot.data[index]["idPubliczne"]
    //               });
    //         },
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(25),
    //             color: Colors.white,
    //           ),
    //           height: 130,
    //           width: 150,
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 flex: widget.data['route_name'] == 'receipts'
    //                     ? (14)
    //                     : (7),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     Padding(
    //                       padding:
    //                           const EdgeInsets.fromLTRB(10, 10, 0, 0),
    //                       child: Text(
    //                           "${snapshot.data[index]["modelName"]["name"]} ${snapshot.data[index]["modelName"]["modeleMarki"]}",
    //                           style: TextStyle(
    //                             fontSize: snapshot
    //                                         .data[index]["modelName"]
    //                                             ["name"]
    //                                         .length >
    //                                     15
    //                                 ? (14)
    //                                 : (18),
    //                           ),
    //                           overflow: TextOverflow.ellipsis),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
    //                       child: Column(
    //                         crossAxisAlignment:
    //                             CrossAxisAlignment.start,
    //                         mainAxisAlignment:
    //                             MainAxisAlignment.center,
    //                         children: [
    //                           if (widget.data["route_name"] ==
    //                               'documents') ...[
    //                             if (widget.data["module_data"][index]
    //                                     ["end_time"] !=
    //                                 null) ...[
    //                               Text("OKRES WAŻNOŚCI",
    //                                   style: TextStyle(
    //                                       color: fontGrey,
    //                                       fontFamily: "Roboto",
    //                                       fontSize: 12,
    //                                       fontWeight: FontWeight.w300,
    //                                       letterSpacing: 1.2)),
    //                               SizedBox(
    //                                 height: 10,
    //                               ),
    //                               Container(
    //                                 decoration: BoxDecoration(
    //                                     borderRadius:
    //                                         BorderRadius.circular(25),
    //                                     color: bg35Grey),
    //                                 child: Padding(
    //                                   padding:
    //                                       const EdgeInsets.fromLTRB(
    //                                           10, 0, 20, 0),
    //                                   child: Row(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.center,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment
    //                                             .spaceAround,
    //                                     children: [
    //                                       Icon(
    //                                           Icons
    //                                               .text_snippet_outlined,
    //                                           color: icon70Black),
    //                                       Text(
    //                                         "${daysBetween(today, DateTime.parse(widget.data["module_data"][index]["end_time"]))} dni",
    //                                         style: TextStyle(
    //                                             fontFamily: "Lato",
    //                                             fontWeight:
    //                                                 FontWeight.w400),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ] else ...[
    //                               Text("DATA DODANIA",
    //                                   style: TextStyle(
    //                                       color: fontGrey,
    //                                       fontFamily: "Roboto",
    //                                       fontSize: 12,
    //                                       fontWeight: FontWeight.w300,
    //                                       letterSpacing: 1.2)),
    //                               SizedBox(
    //                                 height: 10,
    //                               ),
    //                               Container(
    //                                 decoration: BoxDecoration(
    //                                     borderRadius:
    //                                         BorderRadius.circular(25),
    //                                     color: bg35Grey),
    //                                 child: Padding(
    //                                   padding:
    //                                       const EdgeInsets.fromLTRB(
    //                                           10, 0, 20, 0),
    //                                   child: Row(
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.center,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment
    //                                             .spaceAround,
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             EdgeInsets.all(5),
    //                                         child: Text(
    //                                           "${widget.data["module_data"][index]["dateCreated"]}",
    //                                           style: TextStyle(
    //                                               fontFamily: "Lato",
    //                                               fontWeight:
    //                                                   FontWeight
    //                                                       .w400),
    //                                         ),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ] else if (widget.data["route_name"] ==
    //                               'cars') ...[
    //                             Text("OKRES WAŻNOŚCI",
    //                                 style: TextStyle(
    //                                     color: fontGrey,
    //                                     fontFamily: "Roboto",
    //                                     fontSize: 12,
    //                                     fontWeight: FontWeight.w300,
    //                                     letterSpacing: 1.2)),
    //                             SizedBox(
    //                               height: 10,
    //                             ),
    //                             Container(
    //                               decoration: BoxDecoration(
    //                                   borderRadius:
    //                                       BorderRadius.circular(25),
    //                                   color: bg35Grey),
    //                               child: Padding(
    //                                 padding:
    //                                     const EdgeInsets.fromLTRB(
    //                                         10, 0, 20, 0),
    //                                 child: Row(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.center,
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment
    //                                           .spaceAround,
    //                                   children: [
    //                                     Icon(
    //                                         Icons
    //                                             .text_snippet_outlined,
    //                                         color: icon70Black),
    //                                     Text(
    //                                       "${snapshot.data[index]['dataZakupu']} dni",
    //                                       style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontWeight:
    //                                               FontWeight.w400),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                             SizedBox(
    //                               height: 10,
    //                             ),
    //                             Container(
    //                               decoration: BoxDecoration(
    //                                   borderRadius:
    //                                       BorderRadius.circular(25),
    //                                   color: bg35Grey),
    //                               child: Padding(
    //                                 padding: EdgeInsets.fromLTRB(
    //                                     10, 0, 20, 0),
    //                                 child: Row(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.center,
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment
    //                                           .spaceAround,
    //                                   children: [
    //                                     Icon(
    //                                         Icons.car_repair_outlined,
    //                                         color: icon70Black),
    //                                     Text(
    //                                       "${snapshot.data[index]['dataZakupu']} dni",
    //                                       style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontWeight:
    //                                               FontWeight.w400),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             )
    //                           ] else if (widget.data['route_name'] ==
    //                               'receipts') ...[
    //                             Text("PODSTAWOWE INFORMACJE",
    //                                 style: TextStyle(
    //                                     color: fontGrey,
    //                                     fontFamily: "Roboto",
    //                                     fontSize: 10,
    //                                     fontWeight: FontWeight.w300,
    //                                     letterSpacing: 1.2)),
    //                             Padding(
    //                               padding:
    //                                   EdgeInsets.fromLTRB(0, 5, 0, 0),
    //                               child: Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                 children: [
    //                                   Text("Okres zwrotu"),
    //                                   SizedBox(
    //                                     width: 10,
    //                                   ),
    //                                   Text(
    //                                     "${daysBetween(today, DateTime.parse(widget.data['module_data'][index]['refund_time']))} dni",
    //                                     style: TextStyle(
    //                                         fontFamily: "Lato",
    //                                         fontWeight:
    //                                             FontWeight.w400),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:
    //                                   EdgeInsets.fromLTRB(0, 5, 0, 0),
    //                               child: Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                 children: [
    //                                   Text("Okres gwarancji"),
    //                                   SizedBox(
    //                                     width: 10,
    //                                   ),
    //                                   Text(
    //                                     "${daysBetween(today, DateTime.parse(widget.data['module_data'][index]['guarantee_time']))}  dni",
    //                                     style: TextStyle(
    //                                         fontFamily: "Lato",
    //                                         fontWeight:
    //                                             FontWeight.w400),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:
    //                                   EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                               child: Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.start,
    //                                 children: [
    //                                   Text("Cena"),
    //                                   SizedBox(
    //                                     width: 10,
    //                                   ),
    //                                   Text(
    //                                     "${widget.data['module_data'][index]['price']} zł",
    //                                     style: TextStyle(
    //                                         fontFamily: "Lato",
    //                                         fontWeight:
    //                                             FontWeight.w400),
    //                                   )
    //                                 ],
    //                               ),
    //                             )
    //                           ],
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               // FittedBox(child: Image.asset("assets/asterka.jpg"), fit: BoxFit.fill)
    //               Expanded(
    //                 flex: 10,
    //                 child: SizedBox(
    //                   width: 200,
    //                   child: Stack(
    //                     children: [
    //                       Positioned.fill(
    //                         left: 8,
    //                         child: Container(
    //                           padding: const EdgeInsets.fromLTRB(
    //                               0, 100, 200, 0),
    //                           decoration: BoxDecoration(
    //                             borderRadius:
    //                                 BorderRadius.circular(25),
    //                             color: main25Color,
    //                           ),
    //                           width: 90,
    //                           height: 150,
    //                         ),
    //                       ),
    //                       Positioned.fill(
    //                           right: 0,
    //                           child: Align(
    //                             alignment: Alignment.center,
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                 borderRadius:
    //                                     BorderRadius.circular(25),
    //                                 color: main50Color,
    //                               ),
    //                               width: 190,
    //                               height: 150,
    //                             ),
    //                           )),
    //                       if (widget.data["route_name"] ==
    //                           'household') ...[
    //                         Positioned.fill(
    //                           child: Align(
    //                             alignment: Alignment.topRight,
    //                             child: ClipRRect(
    //                               borderRadius:
    //                                   BorderRadius.circular(25),
    //                               child: Image.network(
    //                                 "${snapshot.data[index]['idZdjecia']}",
    //                                 width: 170,
    //                                 height: 150,
    //                                 fit: BoxFit.cover,
    //                                 alignment: Alignment(-0.9, 0),
    //                                 errorBuilder:
    //                                     (BuildContext context,
    //                                         Object exception,
    //                                         StackTrace? stackTrace) {
    //                                   return Align(
    //                                     alignment: Alignment.center,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(
    //                                               25),
    //                                       child: Icon(
    //                                         Icons
    //                                             .not_interested_rounded,
    //                                         size: 88,
    //                                         color: errorColor,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                                 // image: Image.network("${widget.data['data'][index]['image']}"),
    //                                 // image: NetworkImage("${widget.data['data'][index]['image']}"),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ] else if (widget.data["route_name"] ==
    //                           'cars') ...[
    //                         Positioned.fill(
    //                           child: Align(
    //                             alignment: Alignment.topRight,
    //                             child: ClipRRect(
    //                               borderRadius:
    //                                   BorderRadius.circular(25),
    //                               child: Image.network(
    //                                 "${snapshot.data[index]['idZdjecia']}",
    //                                 width: 170,
    //                                 height: 150,
    //                                 fit: BoxFit.cover,
    //                                 alignment: Alignment(-0.5, 0),
    //                                 errorBuilder:
    //                                     (BuildContext context,
    //                                         Object exception,
    //                                         StackTrace? stackTrace) {
    //                                   return Align(
    //                                     alignment: Alignment.center,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(
    //                                               25),
    //                                       child: Icon(
    //                                         Icons
    //                                             .not_interested_rounded,
    //                                         size: 88,
    //                                         color: errorColor,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ] else if (widget.data["route_name"] ==
    //                           'documents') ...[
    //                         Positioned.fill(
    //                           child: Align(
    //                             alignment: Alignment.topRight,
    //                             child: ClipRRect(
    //                               borderRadius:
    //                                   BorderRadius.circular(25),
    //                               child: Image.network(
    //                                 "${widget.data['module_data'][index]['image']}",
    //                                 width: 170,
    //                                 height: 150,
    //                                 fit: BoxFit.cover,
    //                                 alignment: Alignment(-0.5, 0),
    //                                 errorBuilder:
    //                                     (BuildContext context,
    //                                         Object exception,
    //                                         StackTrace? stackTrace) {
    //                                   return Align(
    //                                     alignment: Alignment.center,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(
    //                                               25),
    //                                       child: Icon(
    //                                         Icons
    //                                             .not_interested_rounded,
    //                                         size: 88,
    //                                         color: errorColor,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ] else if (widget.data["route_name"] ==
    //                           'receipts') ...[
    //                         Positioned.fill(
    //                           child: Align(
    //                             alignment: Alignment.topRight,
    //                             child: ClipRRect(
    //                               borderRadius:
    //                                   BorderRadius.circular(25),
    //                               child: Image.network(
    //                                 "${widget.data['module_data'][index]['image']}",
    //                                 width: 115,
    //                                 height: 150,
    //                                 fit: BoxFit.cover,
    //                                 alignment: Alignment(0, 0),
    //                                 errorBuilder:
    //                                     (BuildContext context,
    //                                         Object exception,
    //                                         StackTrace? stackTrace) {
    //                                   return Align(
    //                                     alignment: Alignment.center,
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(
    //                                               25),
    //                                       child: Icon(
    //                                         Icons
    //                                             .not_interested_rounded,
    //                                         size: 88,
    //                                         color: errorColor,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //     separatorBuilder: (BuildContext context, int index) =>
    //         const Divider(
    //       color: Colors.transparent,
    //     ),
    //   ),
    // );
  }
}
