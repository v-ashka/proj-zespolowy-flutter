import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/constants.dart';
import 'package:animations/animations.dart';
import 'package:projzespoloey/main.dart';
import 'package:projzespoloey/pages/dashboard.dart';
import 'package:projzespoloey/pages/form.dart';

class CarItem extends StatefulWidget {
  const CarItem({Key? key}) : super(key: key);

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  Map item = {};

  @override
  Widget build(BuildContext context) {
    item = item.isNotEmpty
        ? item
        : ModalRoute.of(context)?.settings.arguments as Map;
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();

    print(item);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
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
        foregroundColor: Colors.transparent,
        backgroundColor: secondaryColor,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
        title: Text("Paragon - ${item["data"]["name"]}"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item["data"]["car_info"]["image"]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: secondaryColor),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        child: Text("MARKA",
                                            style: TextStyle(
                                              color: fontBlack,
                                              fontSize: 6,
                                            )),
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: mainColor),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 2),
                                        child: Text(
                                          "Opel",
                                          style: TextStyle(
                                            color: fontWhite,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: secondaryColor),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        child: Text("NR REJ.",
                                            style: TextStyle(
                                              color: fontBlack,
                                              fontSize: 6,
                                            )),
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: mainColor),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 2),
                                        child: Text(
                                          "LO ASTRA",
                                          style: TextStyle(
                                            color: fontWhite,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text("MODEL",
                                        style: TextStyle(
                                          color: fontBlack,
                                          fontSize: 6,
                                        )),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    child: Text(
                                      "Astra J",
                                      style: TextStyle(
                                        color: fontWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text("`DATA PROD`.",
                                        style: TextStyle(
                                          color: fontBlack,
                                          fontSize: 6,
                                        )),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    child: Text(
                                      "2019",
                                      style: TextStyle(
                                        color: fontWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text("SILNIK",
                                        style: TextStyle(
                                          color: fontBlack,
                                          fontSize: 6,
                                        )),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    child: Text(
                                      "1.6 Turbo",
                                      style: TextStyle(
                                        color: fontWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Text("VIN",
                                        style: TextStyle(
                                          color: fontBlack,
                                          fontSize: 6,
                                        )),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: mainColor),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    child: Text(
                                      "2T1BR32E67C748616",
                                      style: TextStyle(
                                        color: fontWhite,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: bgSmokedWhite,
                    onPrimary: bg35Grey,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () {
                  print("ubezpieczenie");
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ubezpieczenie",
                              style: TextStyle(
                                fontSize: 20,
                                color: fontBlack,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "OKRES WAŻNOŚCI",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: fontGrey,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "OC",
                                    style: TextStyle(
                                        color: fontBlack,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "320 dni",
                                    style: TextStyle(
                                      color: fontBlack,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "AC",
                                    style: TextStyle(
                                        color: fontBlack,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "brak",
                                    style: TextStyle(
                                      color: fontBlack,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.text_snippet_outlined,
                          size: 82,
                          color: bg50Grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: bgSmokedWhite,
                    onPrimary: bg35Grey,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                onPressed: () {
                  print("ubezpieczenie");
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Przegląd",
                              style: TextStyle(
                                fontSize: 20,
                                color: fontBlack,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "OKRES WAŻNOŚCI PRZEGLĄDU",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: fontGrey,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.car_repair_outlined,
                                    size: 20,
                                    color: fontGrey,
                                  ),
                                  Text(
                                    "320 dni",
                                    style: TextStyle(
                                      color: fontBlack,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.text_snippet_outlined,
                          size: 82,
                          color: bg50Grey,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
