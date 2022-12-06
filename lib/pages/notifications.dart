import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/services/notification_service.dart';

import '../components/appbar.dart';
import '../constants.dart';
import '../models/notification_model.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationList>? notificationList;
  String? token;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    notificationList = (await NotificationApiService().getNotifications(token));
    setState(() {});
  }

  String getPhoto(receiptId) {
    return "$SERVER_IP/api/fileUpload/GetFile/$receiptId?naglowkowy=true";
  }

  void showDeleteDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(context, HeaderTitleType.notification),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Center(
              child: notificationList == null
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: mainColor,
                    ))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: notificationList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notificationItem = notificationList![index];
                          if (notificationList!.isEmpty) {
                            return const Center(
                              child: Text("Trochę tu pusto..."),
                            );
                          } else {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                height: 130,
                                width: 150,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 15, 0, 0),
                                            child: Text(
                                                "${notificationItem.naglowek}",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 10, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("${notificationItem.opis}")
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.history_toggle_off_outlined,
                                              size: 88,
                                              color: bg50Grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Colors.transparent,
                        ),
                      ),
                    ))),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushNamed(
      //       context,
      //       "/receiptForm",
      //     ).then((value) {});
      //   },
      //   backgroundColor: mainColor,
      //   label: const Text('Dodaj nowy'),
      //   icon: const Icon(Icons.add),
      // ),
    );
  }
}
