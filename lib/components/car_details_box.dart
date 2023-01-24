import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/components/delete_button.dart';
import 'package:organizerPRO/components/detail_bar.dart';
import 'package:organizerPRO/components/edit_button.dart';
import 'package:organizerPRO/components/files_button.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/car_model.dart';
import 'package:organizerPRO/screens/cars_module/car_list_view.dart';
import 'package:organizerPRO/screens/cars_module/forms/car_form.dart';
import 'package:organizerPRO/utils/http_delete.dart';

class CarDetailBox extends StatelessWidget {
  final CarModel carModel;
  final String token;
  final BuildContext context;
  const CarDetailBox(
      {Key? key,
      required this.carModel,
      required this.token,
      required this.context})
      : super(key: key);

  pushAndRemoveUntil() async {
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const CarList(),
        ),
        ModalRoute.withName("/dashboard"));
  }

  navigatorEditPush() => Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => CarForm(
        carId: carModel.idSamochodu,
        isEditing: true,
        brand: carModel.marka,
        make: carModel.model)));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: bgSmokedWhite,
        boxShadow: const [
          BoxShadow(
            color: bg35Grey,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ExpandablePanel(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text("Dane pojazdu",
                              style: TextStyle(fontSize: 20, color: fontBlack, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: Text(
                                "Kliknij, aby zobaczyć więcej informacji o pojeździe",
                                style: TextStyle(fontSize: 12, color: fontGrey, fontFamily: "Roboto",
                                    fontWeight: FontWeight.w300),
                              ))])]
                    ),
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      children: [
                        DetailBar(title: "Numer VIN", value: carModel.numerVin!),
                        DetailBar(title: "Pojemność silnika",value: "${carModel.pojemnoscSilnika!.toString()} cm3"),
                        DetailBar(title: "Rodzaj paliwa", value: carModel.rodzajPaliwa!),
                        DetailBar(title: "Skrzynia biegów", value: carModel.rodzajSkrzyniBiegow!),
                        DetailBar(title: "Moc", value: "${carModel.moc.toString()} KM"),
                        DetailBar(title: "Napęd", value: carModel.rodzajNapedu!),
                        DetailBar(title: "Data zakupu", value: carModel.dataZakupu!),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DeleteButton(
                                endpoint: Endpoints.carDefault,
                                token: token,
                                id: carModel.idSamochodu,
                                dialogtype: AlertDialogType.car,
                                callback: pushAndRemoveUntil),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: mainColor,
                            padding: const EdgeInsets.all(5),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            )),
                        onPressed: () => {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CarForm(
                                    carId: carModel.idSamochodu,
                                    isEditing: true,
                                    brand: carModel.marka,
                                    make: carModel.model)))},
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
                            FilesButton(objectId: carModel.idSamochodu!),
                          ],
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
    );
  }
}
