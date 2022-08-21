import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class DocumentsList extends StatefulWidget {
  const DocumentsList({Key? key}) : super(key: key);

  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<DocumentsList> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)?.settings.arguments as Map;
    print("isReceiptVisible? :${data['userData']['cars'][0]['car_info']}");

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    // print(carsData[0]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:  AppBar(
        elevation: 0,
        title: Text('Dokumenty'),
        leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Colors.black,//Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato', fontSize: MediaQuery.of(context).textScaleFactor * 20, color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'), fit: BoxFit.fill)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child:
          ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: data['userData']['documents'].length,
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
                            child: Text("${data['userData']['documents'][index]["title"]}", style: TextStyle(
                              fontSize: data['userData']['documents'][index]['title']!.length > 15 ? (14):(18),
                            ), overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("DATA DODANIA", style: TextStyle(
                                    color: fontGrey,
                                    fontFamily: "Lato",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    letterSpacing: 1.2
                                )),
                                SizedBox(
                                  height: 5,
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
                                        Icon(Icons.calendar_month, color: icon70Black),
                                        Text("${data['userData']['documents'][index]['dateCreated']}",
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
                        width: 150,
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
                                    image: NetworkImage("${data['userData']['documents'][index]['image']}"),
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
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: mainColor,
          icon: const Icon(Icons.add),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
          label: Text(' Dodaj dokument', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),

        ),
      ),
    );
  }
}


