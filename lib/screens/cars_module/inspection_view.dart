import 'package:flutter/material.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/components/box_title_bar.dart';
import 'package:organizerPRO/components/car_image_container.dart';
import 'package:organizerPRO/components/delete_button.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/empty_box.dart';
import 'package:organizerPRO/components/files_button.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/car_model.dart';
import 'package:organizerPRO/models/inspection_model.dart';
import 'package:organizerPRO/screens/cars_module/forms/inspection_form.dart';
import 'package:organizerPRO/screens/cars_module/inspection_history_view.dart';
import 'package:organizerPRO/screens/loading_screen.dart';
import 'package:organizerPRO/services/inspection_service.dart';
import 'package:organizerPRO/utils/http_delete.dart';

class CarServiceView extends StatefulWidget {
  final CarModel car;

  const CarServiceView({Key? key, required this.car}) : super(key: key);

  @override
  State<CarServiceView> createState() => _CarServiceViewState();
}

class _CarServiceViewState extends State<CarServiceView> {
  InspectionModel? inspectionData = InspectionModel();
  String? token;
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    token = await storage.read(key: "token");
    inspectionData = (await InspectionApiService()
        .getInspection(token, widget.car.idSamochodu));
    setState(() {
      isGetDataFinished = true;
    });
  }

  Future refreshData() async {
    setState(() {
      inspectionData = InspectionModel();
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetDataFinished) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.carInspection, "-",
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
                  carRegNumber: widget.car.numerRejestracyjny!,
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.car.koniecPrzegladu == null) ...[
                  EmptyBoxInfo(
                    title: "Dodaj przegląd w kilku krokach",
                    description:
                        "Aktualnie nie dodałeś jeszcze żadnego przeglądu zrób to już teraz klikając w to powiadomienie!",
                    pageRoute: () =>
                        InspectionForm(carId: widget.car.idSamochodu!),
                  )
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
                                    const BoxTitleBar(
                                        title: "Aktualny Przegląd",
                                        description: "DANE DOTYCZĄCE PRZEGLĄDU",
                                        icon: Icons.text_snippet_outlined),
                                    DetailBar(
                                        title: "Stacja diagnostyczna",
                                        value:
                                            "${inspectionData?.nazwaStacjiDiagnostycznej}"),
                                    DetailBar(
                                        title: "Numer badania",
                                        value:
                                            "${inspectionData?.numerBadania}"),
                                    DetailBar(
                                        title: "Wynik badania pojazdu",
                                        value: inspectionData!.czyPozytywny!
                                            ? "Pozytywny"
                                            : "Negatywny"),
                                    DetailBar(
                                        title: "Okres przeglądu",
                                        value:
                                            "${inspectionData?.dataPrzegladu} / ${inspectionData?.koniecWaznosciPrzegladu}"),
                                    DetailBar(
                                      title: "Dodatkowe informacje",
                                      value: inspectionData?.uwagi ??
                                          "Brak dodatkowych informacji",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                            children: [
                              SizedBox(
                                width: 80,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: secondaryColor),
                                  child: Text(
                                      "${widget.car.koniecPrzegladu} dni",
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
                                      endpoint: Endpoints.carInspection,
                                      token: token,
                                      id: inspectionData!.idPrzegladu,
                                      dialogtype: AlertDialogType.carInspection,
                                      callback: getData),
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
                                                InspectionForm(
                                              carId: widget.car.idSamochodu!,
                                              isEditing: true,
                                              editModel: inspectionData,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
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
                                      objectId: inspectionData!.idPrzegladu!)
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: bg35Grey, backgroundColor: bgSmokedWhite,
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InspectionHistory(
                                carId: widget.car.idSamochodu!,
                                carModel: widget.car.model!),
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
                                "Historia Przeglądów",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: fontBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(
                                "ZARCHIWIOZWANE PRZEGLĄDY",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
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
                                        "${widget.car.zarchiwizowanePrzeglady}",
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
                    height: 80,
                  ),
                ]
              ]),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    InspectionForm(carId: widget.car.idSamochodu!),
              ));
        },
        backgroundColor: mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
