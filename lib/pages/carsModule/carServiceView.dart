import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';

class CarServiceView extends StatefulWidget {
  const CarServiceView({Key? key}) : super(key: key);

  @override
  State<CarServiceView> createState() => _CarServiceViewState();
}

class _CarServiceViewState extends State<CarServiceView> {
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
              fontSize: MediaQuery.of(context).textScaleFactor * 18,
              color: Colors.black),
          title: Text("Przegląd - ${item["car"]["modelId"]}"),
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
                    image: item["car"]["idZdjecia"],
                    brand: "Opel",
                    model: "Astra J",
                    prodDate: item["car"]["rokProdukcji"],
                    engine: item["car"]["pojemnoscSilnika"],
                    vinNr: item["car"]["numerVin"],
                    carRegNumber: item["car"]["numerRejestracyjny"]),
                SizedBox(
                  height: 15,
                ),
                if (item["data"].length < 1) ...[
                  Center(child: Text("Trochę tu pusto..."))
                ] else ...[
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
                                              "Aktualny Przegląd",
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
                                                  color: item["data"].first[
                                                              "czyPozytywny"] ==
                                                          true
                                                      ? (secondaryColor)
                                                      : (errorColor)),
                                              child: Text(
                                                item["data"].first[
                                                            "czyPozytywny"] ==
                                                        true
                                                    ? ("aktualny")
                                                    : ("nieaktualny"),
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
                                                  "${item["data"].first["dataPrzegladu"].toString().substring(0, 10)} / ${item["data"].first["dataNastepnegoPrzegladu"].toString().substring(0, 10)}",
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
                                              child: Text(
                                                  "${item["data"].first["uwagi"]}",
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
                                  child: Text(
                                      "${CarApiService().daysBetween(CarApiService().today, DateTime.parse(item["data"].first["dataNastepnegoPrzegladu"]))} dni",
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
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.all(5),
                                          child: AlertDialog(
                                            actionsPadding: EdgeInsets.all(0),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            title: Text(
                                                "Czy na pewno chcesz usunąć ten element?"),
                                            content: Text(
                                                "Po usunięciu nie możesz cofnąć tej akcji."),
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: mainColor,
                                                          onPrimary: mainColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          )),
                                                  onPressed: () {
                                                    print("no");
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Anuluj",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: deleteBtn,
                                                          onPrimary: deleteBtn,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          )),
                                                  onPressed: () {
                                                    print("yes");
                                                  },
                                                  child: Text(
                                                    "Usuń",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
                                        );
                                      });
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(5),
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    onPrimary: mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    )),
                                onPressed: () {
                                  print("edit object");
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: mainColor,
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
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
                      print("historia ubezpieczenie");
                      Navigator.pushNamed(context, "/carServiceHistory",
                          arguments: {"data": item["data"]});
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
                                  "Historia Przeglądów",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: fontBlack,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "ZARCHIWIOZWANE PRZEGLĄDY",
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
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.analytics_outlined,
                                          size: 20,
                                          color: fontGrey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "10",
                                          style: TextStyle(
                                            color: fontBlack,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.manage_history_outlined,
                              size: 82,
                              color: bg50Grey,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ]
              ])),
        ));
  }
}