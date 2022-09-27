import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';

class CarServiceHistory extends StatefulWidget {
  const CarServiceHistory({Key? key}) : super(key: key);

  @override
  State<CarServiceHistory> createState() => _CarServiceHistoryState();
}

class _CarServiceHistoryState extends State<CarServiceHistory> {
  Map item = {};

  @override
  Widget build(BuildContext context) {
    item = item.isNotEmpty
        ? item
        : ModalRoute.of(context)?.settings.arguments as Map;
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();

    print("test: ${item}");
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
              fontSize: MediaQuery.of(context).textScaleFactor * 16,
              color: Colors.black),
          title: Text("Historia Przeglądów - ${item["data"]["name"]}"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: ListView(children: [
                  CarImageContainer(
                      image: item["data"]["car_info"]["image"],
                      brand: "Opel",
                      model: "Astra J",
                      prodDate: item["data"]["car_info"]["production_date"]
                          .toString(),
                      engine: item["data"]["car_info"]["engine"],
                      vinNr: item["data"]["insurance"][0]["oc_insurance_info"]
                          [0]["vin_nr"],
                      carRegNumber: "LO ASTRA"),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                    Row(
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
                                              "Przegląd 12-10-2020",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "DANE DOTYCZĄCE PRZEGLĄDU",
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
                                        Icon(
                                          Icons.text_snippet_outlined,
                                          size: 82,
                                          color: bg50Grey,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Stan przeglądu:  ",
                                            style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: errorColor),
                                              child: Text(
                                                "nieaktualny",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Okres przeglądu:  ",
                                            style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w900,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: secondaryColor),
                                              child: Text(
                                                  "10-08-2022 / 09-08-2023",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          textDirection: TextDirection.ltr,
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: [
                                            Text(
                                              "Dodatkowe informacje:  ",
                                              style: TextStyle(
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: secondaryColor),
                                              child: Text("nowa gaśnica",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: secondaryColor),
                                              child: Text(
                                                  "wymienić lewy przedni amortyzator",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: secondaryColor),
                                              child: Text(
                                                  "klocki hamulcowe na wykończeniu",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "OKRES WAŻNOŚCI PRZEGLĄDU",
                            style: TextStyle(
                                fontSize: 12,
                                color: fontGrey,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Text("320 dni",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(5),
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    onPrimary: deleteBtn,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    )),
                                onPressed: () {
                                  print("delete object");
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: deleteBtn,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 30,
                                    color: bgSmokedWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}
