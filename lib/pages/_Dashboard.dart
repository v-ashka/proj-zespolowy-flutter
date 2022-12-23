import 'package:flutter/material.dart';
import 'package:projzespoloey/components/dashboardBox.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/dashboard_data_model.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/pages/notifications.dart';
import 'package:projzespoloey/pages/settings_view.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/notification_service.dart';

class DashboardPanel extends StatefulWidget {
  const DashboardPanel({Key? key}) : super(key: key);

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  String? token;
  String? userName;
  int? notificationCount;
  bool dashboardDataLoading = true;
  DashboardData dashboardData = DashboardData();
  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    userName = await storage.read(key: "userName");
    token = await storage.read(key: "token");
    notificationCount = await NotificationApiService().getCount(token);
    var response = await UserApiService().getDashboardData(token);
    if (response?.statusCode == 200) {
      dashboardData = DashboardData.fromJson(response!.data);
    }
    setState(() {
      dashboardDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
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
                    const SizedBox(
                      width: 50,
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationView()));
                          },
                          icon: const Icon(Icons.notifications, size: 25),
                        ),
                        if (notificationCount != 0)
                          Positioned(
                            top: 7,
                            left: 25,
                            child: Container(
                              width: 15,
                              height: 15,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "$notificationCount",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsView()));
                      },
                      icon: const Icon(Icons.settings, size: 25),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                if (dashboardDataLoading) ...[
                  const SizedBox(height: 300),
                  const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: mainColor,
                  ))
                ] else
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: secondColor,
                      onRefresh: getDashboardData,
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
                              const SizedBox(height: 40),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                              additionalInfo: dashboardData.ostatniDokument),
                          const SizedBox(
                            height: 15,
                          ),
                          DashboardBox(
                            title: "Paragony",
                            description: "Ostatnio dodany paragon",
                            assetImgPath: 'assets/receipt.svg',
                            lastAdded: dashboardData.ostatniParagon,
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReceiptList()))
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DashboardBox(
                            title: "Samochód",
                            description: "Następny przegląd pojazdu",
                            additionalInfo: dashboardData.dniDoPrzegladu != null
                                ? "${dashboardData.markaModelSamochodu} za ${dashboardData.dniDoPrzegladu} dni"
                                : "",
                            routeLink: '/carList',
                            assetImgPath: 'assets/cars.svg',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DashboardBox(
                            title: "Dom",
                            description: "Liczba dodanych pomieszczeń",
                            additionalInfo:
                                dashboardData.liczbaPomieszczen.toString(),
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeList()))
                            },
                            assetImgPath: 'assets/house.svg',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
