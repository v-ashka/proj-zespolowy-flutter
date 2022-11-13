import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/components/emptyBox.dart';
import 'package:projzespoloey/components/imageContainer.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/insurace_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carInsuranceHistoryView.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/filesView.dart';
import 'package:projzespoloey/pages/carsModule/form/insuranceEditForm.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/car/insurance_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';

import 'form/insuranceForm.dart';

class CarInsuranceView extends StatefulWidget {
  final CarModel car;
  const CarInsuranceView({Key? key, required this.car}) : super(key: key);

  @override
  State<CarInsuranceView> createState() => _CarInsuranceViewState();
}

class _CarInsuranceViewState extends State<CarInsuranceView> {
  final storage = const FlutterSecureStorage();
  Map item = {};
  String? tokenVal;
  InsuranceModel insuranceOC = InsuranceModel();
  InsuranceModel insuranceAC = InsuranceModel();
  // var idSamochodu;
  final completer = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    tokenVal = await storage.read(key: "token");
    insuranceOC = (await getValidOC(tokenVal, widget.car.idSamochodu));
    insuranceAC = (await getValidAC(tokenVal, widget.car.idSamochodu));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final today = DateTime.now();
    if (widget.car.idSamochodu == null) {
      return LoadingScreen();
    }
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
        title: Text("Ubezpieczenie - ${widget.car.marka} ${widget.car.model}"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView(children: [
              CarImageContainer(
                  image: widget.car.idSamochodu!,
                  brand: widget.car.marka!,
                  model: widget.car.model!,
                  prodDate: widget.car.rokProdukcji!,
                  engine: widget.car.pojemnoscSilnika!,
                  vinNr: widget.car.numerVin!,
                  carRegNumber: widget.car.numerRejestracyjny!),
              SizedBox(
                height: 15,
              ),
              if (widget.car.koniecOC == null &&
                  widget.car.koniecAC == null) ...[
                EmptyBoxInfo(
                  title: "Dodaj ubezpieczenie w kilku krokach",
                  description:
                      "Aktualnie nie dodałeś jeszcze żadnego ubezpieczenia, zrób to już teraz",
                  pageRoute: () => InsuranceForm(carId: widget.car.idSamochodu),
                ),
              ] else ...[
                if (widget.car.koniecOC != null)
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
                                              "Polisa OC",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "DANE DOTYCZĄCE POLISY",
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
                                            "Numer polisy:  ",
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
                                                "${insuranceOC.nrPolisy}",
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
                                            "Nazwa firmy ubezpieczeniowej:  ",
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
                                                  "${insuranceOC.ubezpieczyciel}",
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Okres ubezpieczenia:  ",
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
                                                  "${insuranceOC.dataZakupu}  /  ${insuranceOC.dataKonca}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
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
                                            "Składka OC:  ",
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
                                                  "${insuranceOC.kosztPolisy} zł",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
                                            ),
                                          ),
                                        ],
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
                            "OKRES WAŻNOŚCI POLISY",
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
                            children: [
                              SizedBox(
                                width: 80,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Text("${widget.car.koniecOC} dni",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DeleteButton(
                                      endpoint: Endpoints.carInsurance,
                                      token: tokenVal,
                                      id: insuranceOC.idUbezpieczenia,
                                      dialogtype: AlertDialogType.carInspection,
                                      callback: _getData),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(5),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        onPrimary: mainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    onPressed: () {
                                      print("edit object");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InsuranceEditForm(
                                                    insurance: insuranceOC,
                                                    carId: widget
                                                        .car.idSamochodu!),
                                          ));
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
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(5),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: mainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    onPressed: () {
                                      print("file list");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FilesView(
                                                objectId: insuranceOC
                                                    .idUbezpieczenia!),
                                          ));
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: secondColor,
                                      ),
                                      child: Icon(
                                        Icons.file_open_outlined,
                                        size: 30,
                                        color: bgSmokedWhite,
                                      ),
                                    ),
                                  ),
                                ],
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
                if (insuranceAC.idUbezpieczenia != null) ...[
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
                                              "Polisa AC",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "DANE DOTYCZĄCE POLISY",
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
                                            "Numer polisy:  ",
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
                                                "${insuranceAC.nrPolisy}",
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
                                            "Nazwa firmy ubezpieczeniowej:  ",
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
                                                  "${insuranceAC.ubezpieczyciel}",
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Okres ubezpieczenia:  ",
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
                                                  "${insuranceAC.dataZakupu}  /  ${insuranceAC.dataKonca}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
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
                                            "Składka AC:  ",
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
                                                  "${insuranceAC.kosztPolisy} zł",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: fontBlack)),
                                            ),
                                          ),
                                        ],
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
                            "OKRES WAŻNOŚCI POLISY",
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
                            children: [
                              SizedBox(
                                width: 80,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Text("${widget.car.koniecAC} dni",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: fontBlack)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(5),
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        onPrimary: deleteBtn,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    onPressed: () {
                                      print("delete object");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: EdgeInsets.all(5),
                                              child: AlertDialog(
                                                actionsPadding:
                                                    EdgeInsets.all(0),
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
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  mainColor,
                                                              onPrimary:
                                                                  mainColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              )),
                                                      onPressed: () {
                                                        print("no");
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Anuluj",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  deleteBtn,
                                                              onPrimary:
                                                                  deleteBtn,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              )),
                                                      onPressed: () async {
                                                        print("yes");
                                                        // insuranceData.IdUbezpieczenia
                                                        tokenVal = await storage
                                                            .read(key: "token");
                                                        var deleteRes =
                                                            await deleteInsurance(
                                                                tokenVal,
                                                                insuranceAC
                                                                    .idUbezpieczenia);
                                                        setState(() {
                                                          if (deleteRes) {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute<
                                                                        void>(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          CarItem(
                                                                              carId: widget.car.idSamochodu!),
                                                                    ),
                                                                    ModalRoute
                                                                        .withName(
                                                                            "/dashboard"));
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        "Usuń",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    onPressed: () {
                                      print("edit object");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InsuranceEditForm(
                                                    insurance: insuranceAC,
                                                    carId: widget
                                                        .car.idSamochodu!),
                                          ));
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
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(5),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: mainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                    onPressed: () {
                                      print("file list");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FilesView(
                                                objectId: insuranceAC
                                                    .idUbezpieczenia!),
                                          ));
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: secondColor,
                                      ),
                                      child: Icon(
                                        Icons.file_open_outlined,
                                        size: 30,
                                        color: bgSmokedWhite,
                                      ),
                                    ),
                                  ),
                                ],
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
                ]
              ],
              if (insuranceOC.idUbezpieczenia != null ||
                  insuranceAC.idUbezpieczenia != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: bgSmokedWhite,
                      onPrimary: bg35Grey,
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CarInsuranceHistoryView(car: widget.car),
                        ));
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
                                "Historia Ubezpieczeń",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: fontBlack,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "ILOŚĆ ZARCHIWIOZWANYCH POLIS",
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        "${widget.car.zarchiwizowanePolisy}",
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
                height: 100,
              ),
            ])),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InsuranceForm(carId: widget.car.idSamochodu),
              ));
        },
        backgroundColor: mainColor,
        label: Text('Dodaj nowy'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
