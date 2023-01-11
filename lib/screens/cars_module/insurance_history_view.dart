import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/components/delete_button.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/files_button.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/insurace_model.dart';
import 'package:organizerPRO/models/car_model.dart';
import 'package:organizerPRO/screens/loading_screen.dart';
import 'package:organizerPRO/services/insurance_service.dart';
import 'package:organizerPRO/utils/http_delete.dart';

class CarInsuranceHistoryView extends StatefulWidget {
  final CarModel? car;

  const CarInsuranceHistoryView({Key? key, required this.car})
      : super(key: key);

  @override
  State<CarInsuranceHistoryView> createState() =>
      _CarInsuranceHistoryViewState();
}

class _CarInsuranceHistoryViewState extends State<CarInsuranceHistoryView> {
  List<InsuranceModel> insuranceList = [];
  String? token;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    insuranceList = await getInsuranceList(token, widget.car!.idSamochodu);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.car!.idSamochodu == null) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.carInsuracneHistory, "-",
          widget.car?.marka, widget.car?.model),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.transparent,
                    ),
                itemCount: insuranceList.length,
                itemBuilder: (BuildContext context, int index) {
                  final insurance = insuranceList[index];
                  return Container(
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
                                    ExpandablePanel(
                                      header: Row(
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
                                                insurance.idRodzajuUbezpieczenia ==
                                                        1
                                                    ? "Polisa OC"
                                                    : "Polisa AC",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
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
                                        ],
                                      ),
                                      collapsed: DetailBar(
                                          title: "Okres ubezpieczenia",
                                          value:
                                              "${insurance.dataZakupu} / ${insurance.dataKonca}"),
                                      expanded: Column(children: [
                                        DetailBar(
                                            title: "Numer polisy",
                                            value: insurance.nrPolisy!),
                                        DetailBar(
                                            title: "Nazwa ubezpieczyciela",
                                            value: insurance.ubezpieczyciel!),
                                        DetailBar(
                                            title: "Okres ubezpieczenia",
                                            value:
                                                "${insurance.dataZakupu} / ${insurance.dataKonca}"),
                                        DetailBar(
                                            title: insurance
                                                        .idRodzajuUbezpieczenia ==
                                                    1
                                                ? "Składka OC"
                                                : "Składka AC",
                                            value: "${insurance.kosztPolisy} zł"
                                                .toString()),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 0, 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DeleteButton(
                                                      endpoint: Endpoints
                                                          .carInsurance,
                                                      token: token,
                                                      id: insurance
                                                          .idUbezpieczenia,
                                                      dialogtype:
                                                          AlertDialogType
                                                              .carInsurance,
                                                      callback: getData),
                                                  FilesButton(objectId: insurance.idUbezpieczenia!)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })),
      ),
    );
  }
}
