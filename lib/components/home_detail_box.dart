import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/delete_button.dart';
import 'package:projzespoloey/components/detail_bar.dart';
import 'package:projzespoloey/components/files_button.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/home_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/pages/carsModule/form/car_form.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/utils/http_delete.dart';

class HomeDetailBox extends StatelessWidget {
  final HomeModel homeModel;
  final String token;
  final BuildContext context;
  const HomeDetailBox({Key? key, required this.homeModel, required this.token, required this.context}) : super(key: key);

  pushAndRemoveUntil() async{
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeList(),
        ),
        ModalRoute.withName("/dashboard"));
  }

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
                            Text(
                              "Informacje o domu",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: fontBlack,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: Text(
                                "Kliknij, aby zobaczyć więcej informacji",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: fontGrey,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      children: [
                        DetailBar(title: "Rodzaj domu", value: homeModel.typDomu!),
                        DetailBar(title: "Ulica i numer domu", value: homeModel.ulicaNrDomu!),
                        DetailBar(title: "Miejscowość", value: homeModel.miejscowosc!),
                        DetailBar(title: "Kod pocztowy", value: homeModel.kodPocztowy!),
                        DetailBar(title: "Rok wprowadzenia", value: homeModel.rokWprowadzenia!),
                        DetailBar(title: "Powierzchnia domu", value: "${homeModel.powierzchniaDomu!} m\u{00B2}"),
                        if(homeModel.idTypDomu == 1)
                          DetailBar(title: "Powierzchnia domu", value: homeModel.powierzchniaDzialki!),
                        DetailBar(title: "Liczba pokoi", value: homeModel.liczbaPokoi!),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DeleteButton(
                                endpoint: Endpoints.carDefault,
                                token: token,
                                id: homeModel.idDomu,
                                dialogtype: AlertDialogType.car,
                                callback: pushAndRemoveUntil),
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => CarForm(
                                //           carId: homeModel.idSamochodu,
                                //           isEditing: true,
                                //           brand: homeModel.marka,
                                //           make: homeModel.model),
                                //     ));
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
                            FilesButton(objectId: homeModel.idDomu!),
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
