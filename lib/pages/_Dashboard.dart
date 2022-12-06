import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:projzespoloey/components/dashboardBox.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/pages/notifications.dart';
import 'package:projzespoloey/pages/settings_view.dart';
import 'package:projzespoloey/services/notification_service.dart';

class DashboardPanel extends StatefulWidget {
  const DashboardPanel({Key? key}) : super(key: key);

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  String? userData;
  String? userName;
  int? notificationCount;
  bool notificationLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserToken();
    getNotificationCount();
  }

  void getUserToken() async {
    userData = await storage.read(key: "token");
    userName = await storage.read(key: "userName");
    setState(() {});
  }

  void getNotificationCount() async {
    notificationLoading = true;
    userData = await storage.read(key: "token");
    notificationCount = await NotificationApiService().getCount(userData);
    setState(() {
      notificationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                          text: 'Organizer',
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'PRO',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: mainColor))
                          ]),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          top: 7,
                          left: 25,
                          child: Container(
                            width: 13,
                            height: 13,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              notificationLoading
                                  ? ("0")
                                  : ("${notificationCount}"),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            print("notifications");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationView()));
                          },
                          icon: const Icon(Icons.notifications, size: 25),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        print("settings");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsView()));
                      },
                      icon: const Icon(Icons.settings, size: 25),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Witaj,',
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w300),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' $userName!',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: mainColor))
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Zarządzaj swoim ekranem głównym, ustawiając moduły do wyświetlenia",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                      const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: Text(
                          "Kategorie",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      DashboardBox(
                          title: "Dokumenty",
                          description: "Ostatnio dodany dokument",
                          routeLink: '/documentList',
                          assetImgPath: 'assets/my_files.svg',
                          user: userData),
                      SizedBox(
                        height: 15,
                      ),
                      DashboardBox(
                          title: "Paragony",
                          description: "Ostatnio dodany paragon",
                          assetImgPath: 'assets/receipt.svg',
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReceiptList()))
                              },
                          user: userData),
                      SizedBox(
                        height: 15,
                      ),
                      DashboardBox(
                          title: "Samochód",
                          description: "Następny przegląd za",
                          routeLink: '/carList',
                          assetImgPath: 'assets/cars.svg',
                          user: userData),
                      SizedBox(
                        height: 15,
                      ),
                      DashboardBox(
                          title: "Dom",
                          description: "Liczba dodanych pomieszczeń",
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeList()))
                              },
                          assetImgPath: 'assets/house.svg',
                          user: userData),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
