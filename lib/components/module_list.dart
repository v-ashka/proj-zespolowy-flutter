import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({Key? key, required this.data, required this.size}) : super(key: key);


  final Map data;
  final Size size;
  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child:
                ListView.separated(
                padding: const EdgeInsets.all(20),
                  itemCount: widget.data['module_data'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
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
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 0 ,0),
                                        child: Text("${widget.data['module_data'][index]["name"]}", style: TextStyle(
                                          fontSize: widget.data['module_data'][index]['name']!.length > 15 ? (14):(18),
                                        ), overflow: TextOverflow.ellipsis),
                                      ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("OKRES WAŻNOŚCI", style: TextStyle(
                                                  color: fontGrey,
                                                  fontFamily: "Roboto",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  letterSpacing: 1.2
                                                )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(25),
                                                    color: bg35Grey
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(10,0,20,0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Icon(Icons.text_snippet_outlined, color: icon70Black),
                                                        Text("${widget.data['module_data'][index]['insurance_time']} dni",
                                                          style: TextStyle(
                                                          fontFamily: "Lato",
                                                          fontWeight: FontWeight.w400
                                                          ),
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
                                                      color: bg35Grey
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Icon(Icons.car_repair_outlined, color: icon70Black),
                                                        Text("${widget.data['module_data'][index]['car_service_time']} dni",
                                                          style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontWeight: FontWeight.w400
                                                          ),
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
                                          padding: const EdgeInsets.fromLTRB(0, 100, 200, 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: main25Color,

                                          ),
                                          width: 90,
                                          height: 150,
                                        ),
                                      ),
                                      Positioned.fill(
                                          right: 70,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: main50Color,
                                              ),
                                              width: 90,
                                              height: 150,
                                            ),
                                          )
                                      ),
                                      if(widget.data["route_name"] == 'household') ...[
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image(
                                              width: 170,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(-0.5,0),
                                              image: NetworkImage("${widget.data['module_data'][index]['image']}"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ] else if (widget.data["route_name"] == 'cars')...[
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image(
                                              width: 170,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(-0.5,0),
                                              image: NetworkImage("${widget.data['module_data'][index]['car_info']['image']}"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ] else if (widget.data["route_name"] == 'documents')...[
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image(
                                              width: 170,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(-0.5,0),
                                              image: NetworkImage("${widget.data['module_data'][index]['image']}"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ] else if (widget.data["route_name"] == 'receipts')...[
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image(
                                              width: 170,
                                              height: 150,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(-0.5,0),
                                              image: NetworkImage("${widget.data['module_data'][index]['image']}"),
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
          ),
        );
  }
}