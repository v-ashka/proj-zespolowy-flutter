import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/components/box_title_bar.dart';
import 'package:organizerPRO/components/delete_button.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/empty_box.dart';
import 'package:organizerPRO/components/files_button.dart';
import 'package:organizerPRO/components/car_image_container.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/insurace_model.dart';
import 'package:organizerPRO/models/car_model.dart';
import 'package:organizerPRO/screens/cars_module/forms/insurance_form.dart';
import 'package:organizerPRO/screens/cars_module/insurance_history_view.dart';
import 'package:organizerPRO/screens/loading_screen.dart';
import 'package:organizerPRO/services/insurance_service.dart';
import 'package:organizerPRO/utils/http_delete.dart';


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
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    tokenVal = await storage.read(key: "token");
    insuranceOC = (await getValidOC(tokenVal, widget.car.idSamochodu));
    insuranceAC = (await getValidAC(tokenVal, widget.car.idSamochodu));
    setState(() {
      isGetDataFinished = true;
    });
  }

  Future refreshData() async {
    setState(() {
      insuranceAC = InsuranceModel();
      insuranceOC = InsuranceModel();
      isGetDataFinished = false;
    });
    await _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.car.idSamochodu == null || isGetDataFinished == false) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.carInsurance, "-",
          widget.car.marka, widget.car.model),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: RefreshIndicator(
              color: mainColor,
              onRefresh: refreshData,
              child: ListView(children: [
                CarImageContainer(
                    image: widget.car.idSamochodu!,
                    brand: widget.car.marka!,
                    model: widget.car.model!,
                    prodYear: widget.car.rokProdukcji!,
                    carRegNumber: widget.car.numerRejestracyjny!),
                const SizedBox(
                  height: 15,
                ),
                if (widget.car.koniecOC == null &&
                    widget.car.koniecAC == null) ...[
                  EmptyBoxInfo(
                    title: "Dodaj ubezpieczenie w kilku krokach",
                    description:
                        "Aktualnie nie dodałeś jeszcze żadnego ubezpieczenia, zrób to już teraz",
                    pageRoute: () =>
                        InsuranceForm(carId: widget.car.idSamochodu),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const BoxTitleBar(
                                          title: "Polisa OC",
                                          description: "DANE DOTYCZĄCE POLISY",
                                          icon: Icons.text_snippet_outlined),
                                      DetailBar(
                                          title: "Numer polisy",
                                          value: insuranceOC.nrPolisy!),
                                      DetailBar(
                                          title: "Nazwa firmy ubezpieczeniowej",
                                          value: insuranceOC.ubezpieczyciel!),
                                      DetailBar(
                                          title: "Okres ubezpieczenia",
                                          value:
                                              "${insuranceOC.dataZakupu}  /  ${insuranceOC.dataKonca}"),
                                      DetailBar(
                                          title: "Składka OC",
                                          value:
                                              "${insuranceOC.kosztPolisy} zł")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: secondaryColor),
                                    child: Text("${widget.car.koniecOC} dni",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: fontBlack)),
                                  ),
                                ),
                                const SizedBox(
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
                                      dialogtype: AlertDialogType.carInsurance,
                                      callback: _getData,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: mainColor,
                                          backgroundColor: Colors.transparent,
                                          padding: const EdgeInsets.all(5),
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InsuranceForm(
                                                      editModel: insuranceOC,
                                                      isEditing: true,
                                                      carId: widget
                                                          .car.idSamochodu!),
                                            ));
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: mainColor,
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 30,
                                          color: bgSmokedWhite,
                                        ),
                                      ),
                                    ),
                                    FilesButton(
                                        objectId: insuranceOC.idUbezpieczenia!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const BoxTitleBar(
                                          title: "Polisa AC",
                                          description: "DANE DOTYCZĄCE POLISY",
                                          icon: Icons.text_snippet_outlined),
                                      DetailBar(
                                          title: "Numer polisy",
                                          value: insuranceAC.nrPolisy!),
                                      DetailBar(
                                          title: "Nazwa firmy ubezpieczeniowej",
                                          value: insuranceAC.ubezpieczyciel!),
                                      DetailBar(
                                          title: "Okres ubezpieczenia",
                                          value:
                                              "${insuranceAC.dataZakupu}  /  ${insuranceAC.dataKonca}"),
                                      DetailBar(
                                          title: "Składka AC",
                                          value:
                                              "${insuranceAC.kosztPolisy} zł")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: secondaryColor),
                                    child: Text("${widget.car.koniecAC} dni",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: fontBlack)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DeleteButton(
                                        endpoint: Endpoints.carInsurance,
                                        token: tokenVal,
                                        id: insuranceAC.idUbezpieczenia,
                                        dialogtype:
                                            AlertDialogType.carInsurance,
                                        callback: _getData),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: mainColor,
                                          backgroundColor: Colors.transparent,
                                          padding: const EdgeInsets.all(5),
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InsuranceForm(
                                                      carId: widget
                                                          .car.idSamochodu!,
                                                      isEditing: true,
                                                      editModel: insuranceAC),
                                            ));
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: mainColor,
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 30,
                                          color: bgSmokedWhite,
                                        ),
                                      ),
                                    ),
                                    FilesButton(
                                        objectId: insuranceAC.idUbezpieczenia!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ]
                ],
                if (insuranceOC.idUbezpieczenia != null ||
                    insuranceAC.idUbezpieczenia != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: bg35Grey,
                        backgroundColor: bgSmokedWhite,
                        padding: const EdgeInsets.all(0),
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Historia Ubezpieczeń",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: fontBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(
                                "ILOŚĆ ZARCHIWIOZWANYCH POLIS",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: fontGrey,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 100,
                                padding: const EdgeInsets.all(5),
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
                                      const Icon(
                                        Icons.analytics_outlined,
                                        size: 20,
                                        color: fontGrey,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${widget.car.zarchiwizowanePolisy}",
                                        style: const TextStyle(
                                          color: fontBlack,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.manage_history_outlined,
                            size: 82,
                            color: bg50Grey,
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 100,
                ),
              ]),
            )),
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
        label: const Text('Dodaj nowy'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
