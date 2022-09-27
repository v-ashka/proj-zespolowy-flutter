import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({Key? key, required this.data, required this.size})
      : super(key: key);

  final Map data;
  final Size size;
  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data);
    // DateTime date1 = DateTime.parse(widget.data["data"][1]['end_time']);
    // print(date1);
    // print("${widget.data["data"][0]["name"]}");
    final today = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        // itemCount: widget.data['module_data'].length,
        itemCount: widget.data['module_data'].length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,
                  "/${widget.data['route_name'].toString().substring(0, widget.data['route_name'].toString().length - 1)}Item",
                  arguments: {"data": widget.data["module_data"][index]});
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: widget.data['route_name'] == 'receipts' ? (14) : (7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text(
                              "${widget.data['module_data'][index]["name"]}",
                              style: TextStyle(
                                fontSize: widget
                                            .data['module_data'][index]['name']
                                            .length >
                                        15
                                    ? (14)
                                    : (18),
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.data["route_name"] == 'documents') ...[
                                if (widget.data["module_data"][index]
                                        ["end_time"] !=
                                    null) ...[
                                  Text("OKRES WAŻNOŚCI",
                                      style: TextStyle(
                                          color: fontGrey,
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.2)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: bg35Grey),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 20, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(Icons.text_snippet_outlined,
                                              color: icon70Black),
                                          Text(
                                            "${daysBetween(today, DateTime.parse(widget.data["module_data"][index]["end_time"]))} dni",
                                            style: TextStyle(
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Text("DATA DODANIA",
                                      style: TextStyle(
                                          color: fontGrey,
                                          fontFamily: "Roboto",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.2)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: bg35Grey),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 20, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "${widget.data["module_data"][index]["dateCreated"]}",
                                              style: TextStyle(
                                                  fontFamily: "Lato",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ] else if (widget.data["route_name"] ==
                                  'cars') ...[
                                Text("OKRES WAŻNOŚCI",
                                    style: TextStyle(
                                        color: fontGrey,
                                        fontFamily: "Roboto",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.2)),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: bg35Grey),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.text_snippet_outlined,
                                            color: icon70Black),
                                        Text(
                                          "${widget.data['module_data'][index]['insurance_time']} dni",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w400),
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
                                      borderRadius: BorderRadius.circular(25),
                                      color: bg35Grey),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.car_repair_outlined,
                                            color: icon70Black),
                                        Text(
                                          "${widget.data['module_data'][index]['car_service_time']} dni",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ] else if (widget.data['route_name'] ==
                                  'receipts') ...[
                                Text("PODSTAWOWE INFORMACJE",
                                    style: TextStyle(
                                        color: fontGrey,
                                        fontFamily: "Roboto",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.2)),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Okres zwrotu"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${daysBetween(today, DateTime.parse(widget.data['module_data'][index]['refund_time']))} dni",
                                        style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Okres gwarancji"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${daysBetween(today, DateTime.parse(widget.data['module_data'][index]['guarantee_time']))}  dni",
                                        style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Cena"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${widget.data['module_data'][index]['price']} zł",
                                        style: TextStyle(
                                            fontFamily: "Lato",
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                )
                              ],
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
                                  const EdgeInsets.fromLTRB(0, 100, 200, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
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
                                    borderRadius: BorderRadius.circular(25),
                                    color: main50Color,
                                  ),
                                  width: 190,
                                  height: 150,
                                ),
                              )),
                          if (widget.data["route_name"] == 'household') ...[
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    "${widget.data['module_data'][index]['image']}",
                                    width: 170,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(-0.9, 0),
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Icon(
                                            Icons.not_interested_rounded,
                                            size: 88,
                                            color: errorColor,
                                          ),
                                        ),
                                      );
                                    },
                                    // image: Image.network("${widget.data['data'][index]['image']}"),
                                    // image: NetworkImage("${widget.data['data'][index]['image']}"),
                                  ),
                                ),
                              ),
                            ),
                          ] else if (widget.data["route_name"] == 'cars') ...[
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    "${widget.data['module_data'][index]['car_info']['image']}",
                                    width: 170,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(-0.5, 0),
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Icon(
                                            Icons.not_interested_rounded,
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
                          ] else if (widget.data["route_name"] ==
                              'documents') ...[
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    "${widget.data['module_data'][index]['image']}",
                                    width: 170,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(-0.5, 0),
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Icon(
                                            Icons.not_interested_rounded,
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
                          ] else if (widget.data["route_name"] ==
                              'receipts') ...[
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    "${widget.data['module_data'][index]['image']}",
                                    width: 115,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment(0, 0),
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Icon(
                                            Icons.not_interested_rounded,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
