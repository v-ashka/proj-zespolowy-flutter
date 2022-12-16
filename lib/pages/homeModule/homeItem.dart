import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/home_detail_box.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/home_model.dart';
import 'package:projzespoloey/pages/homeModule/home_repair_list.dart';
import 'package:projzespoloey/pages/homeModule/room_list.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/home_service.dart';

import '../../components/appbar.dart';

class HomeItem extends StatefulWidget {
  String? homeId;

  HomeItem({Key? key, required this.homeId}) : super(key: key);

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  late HomeModel? homeModel = HomeModel();
  String? token = "";
  String carId = "";
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    _getData(widget.homeId);
  }

  _getData(id) async {
    token = await storage.read(key: "token");
    homeModel = await HomeService().getHome(id, token);
    setState(() {
      isGetDataFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGetDataFinished) {
      return const LoadingScreen();
    }
    return Scaffold(
      appBar:
          myAppBar(context, HeaderTitleType.home, "-", homeModel!.miejscowosc),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: homeModel?.idDomu == null
              ? ((Center(
                  child: CircularProgressIndicator(
                  color: mainColor,
                ))))
              : (ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 2.6,
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "$SERVER_IP/api/fileUpload/GetFile/${homeModel!.idDomu}?naglowkowy=true"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    HomeDetailBox(homeModel: homeModel!, token: token!, context: context),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RoomList(homeId: homeModel!.idDomu!, homeLocation: homeModel!.miejscowosc!),
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
                                  const Text(
                                    "Zdjęcia pomieszczeń",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  if (homeModel!.liczbaDodanychPomieszczen != null) ...[
                                    const Text(
                                      "ILOŚĆ DODANYCH POMIESZCZEŃ",
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
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Icon(
                                          //   Icons.door_back_door_outlined,
                                          //   size: 20,
                                          //   color: fontGrey,
                                          // ),
                                          Text(
                                            // homeModel!.koniecPrzegladu != null
                                            //     ? "${homeModel!.koniecPrzegladu} dni"
                                            //     : "Brak",
                                            "5",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nie dodałeś jeszcze żadnych zdjęć!",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Po dodaniu pomieszczeń w tym miejscu pojawi się ich liczba.",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Icon(
                                Icons.door_back_door_outlined,
                                size: 82,
                                color: bg50Grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
                                  HomeRepairList(homeId: homeModel!.idDomu!),
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
                                  const Text(
                                    "Dziennik napraw",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: fontBlack,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  if (homeModel!.liczbaDodanychPomieszczen != null) ...[
                                    const Text(
                                      "ILOŚĆ DODANYCH NAPRAW",
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
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Icon(
                                          //   Icons.door_back_door_outlined,
                                          //   size: 20,
                                          //   color: fontGrey,
                                          // ),
                                          Text(
                                            // homeModel!.koniecPrzegladu != null
                                            //     ? "${homeModel!.koniecPrzegladu} dni"
                                            //     : "Brak",
                                            "5",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    SizedBox(
                                      width: 240,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nie dodałeś jeszcze żadnych napraw!",
                                            style: TextStyle(
                                                color: fontBlack,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Po dodaniu napraw w tym miejscu pojawi się ich liczba.",
                                            style: TextStyle(
                                              color: fontBlack,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Icon(
                                Icons.plumbing_outlined,
                                size: 82,
                                color: bg50Grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    ), const SizedBox(height: 30)
                  ],
                )),
        ),
      ),
    );
  }
}
