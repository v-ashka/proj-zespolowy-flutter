import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:open_file/open_file.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/components/dashboardBox.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:projzespoloey/services/UserModel/UserModel.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/file_picker.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final formKey = GlobalKey<FormState>();
  String? userData;
  Dio dio = Dio();
  late StateSetter _setStateModal;
  double progress = 0.0;
  String fileFeedback = "";
  bool fileStatus = false;

  @override
  void initState() {
    super.initState();
    getUserToken();
  }

  getUserToken() async {
    userData = await storage.read(key: "token");
    setState(() {});
  }

  void removeUserToken() async {
    await storage.deleteAll();
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              titlePadding: EdgeInsets.fromLTRB(25, 25, 25, 0),
              contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text("Nastąpi wylogowanie z konta.."),
              content: Container(
                width: 200,
                height: 200,
                child: Center(
                    child: CircularProgressIndicator(
                  color: mainColor,
                )),
              ),
            );
          });
      print("test");
    });
  }

  void showAboutUsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: AlertDialog(
              actionsPadding: const EdgeInsets.all(0),
              actionsAlignment: MainAxisAlignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: const Text("Autorzy aplikacji"),
              content: SizedBox(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Michał Grabowiec"),
                    Text("Marcin Wijaszka"),
                    Text("Sebastian Wiktor"),
                    Divider(),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Politechnika Lubelska - 2022")),
                    Divider(),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(25, 15, 25, 0),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: fontWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      )),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Zamknij",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        });
  }

  void showChangePassDialog(
    isShowing,
    String headlineText,
    String description,
    String firstLabel,
    String secLabel,
  ) {
    var isLoading = false;
    ChangeUserPass data = ChangeUserPass();
    data.email = Jwt.parseJwt(userData!)[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
    bool obscurePass1 = true;
    bool obscurePass2 = true;
    String errorFeedback = "";

    if (isShowing) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                titlePadding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                contentPadding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                title: Text(headlineText),
                content: SizedBox(
                    height: 300,
                    width: 300,
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Text(description),
                          isLoading
                              ? (const Center(
                                  child: CircularProgressIndicator(
                                      color: mainColor)))
                              : (Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                          obscureText: obscurePass1,
                                          onSaved: (value) {
                                            data.oldPass = value;
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () => setState(() {
                                                  obscurePass1 = !obscurePass1;
                                                }),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 1, 15, 0),
                                                icon: Icon(
                                                  obscurePass1
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.password_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Podaj stare hasło",
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'To pole nie może być puste!';
                                            }
                                            return null;
                                          }),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                          obscureText: obscurePass2,
                                          onSaved: (value) {
                                            data.newPass = value;
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () => setState(() {
                                                  print("test");
                                                  print(obscurePass2);
                                                  obscurePass2 = !obscurePass2;
                                                }),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 1, 15, 0),
                                                icon: Icon(
                                                  obscurePass2
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.password_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Podaj nowe hasło",
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'To pole nie może być puste!';
                                            }
                                            return null;
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: Text(
                                          errorFeedback,
                                          style: TextStyle(color: errorColor),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          15,
                                          0,
                                          0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: deleteBtn,
                                                  foregroundColor:
                                                      bgSmokedWhite,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Anuluj")),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: mainColor,
                                                  foregroundColor:
                                                      bgSmokedWhite,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                ),
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    formKey.currentState!
                                                        .save();
                                                    setState(() {
                                                      isLoading = true;
                                                      headlineText =
                                                          "Zmieniam...";
                                                      description =
                                                          "Po zmianie hasła nastąpi wylogowanie...";
                                                    });

                                                    var res =
                                                        await UserApiService()
                                                            .changePassword(
                                                                data, userData);
                                                    print("test complete");
                                                    if (res) {
                                                      print("testt complete");
                                                      setState(() {
                                                        headlineText =
                                                            "Hasło zostało zmienione!";
                                                        description =
                                                            "Wylogowywuję z konta..";
                                                        removeUserToken();
                                                      });
                                                      await Future.delayed(
                                                          Duration(seconds: 5));
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/',
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    } else {
                                                      setState(() {
                                                        isLoading = !isLoading;
                                                        headlineText =
                                                            "Hasło nie zostało zmienione!";
                                                        description =
                                                            "Wystąpił błąd w trakcie zmiany hasła";
                                                        errorFeedback =
                                                            "Stare hasło jest nieprawidłowe";
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Text("Zapisz zmiany")),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                        ]))),
              );
            });
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future exportFile(String filetype) async {
    String url =
        "https://downloads.wordpress.org/plugin/google-sitemap-generator.4.1.7.zip";
    String fileName = "organizerProFiles_${DateTime.now().year}.$filetype";

    String path = await getFilePath(fileName);

    await dio.download(
      url,
      path,
      onReceiveProgress: (received, totalSize) {
        setState(() {
          progress = received / totalSize;
          print(progress);
        });
      },
      deleteOnError: true,
    ).then((_) {
      setState(() {
        progress;
        fileStatus = false;
      });
      return true;
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification(filepath) async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log(details.toString());
        // OpenFile.open(filepath);
      },
    );
  }

  void importExportAlert() {
    bool fileReady = false;
    List<PlatformFile> files = [];
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateModal) {
            this._setStateModal = setStateModal;
            return AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              titlePadding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
              contentPadding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text("Eksportuj lub importuj pliki"),
              content: SizedBox(
                  height: 220,
                  width: 300,
                  child: Container(
                      child: Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor,
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(40),
                                    ),
                                    onPressed: fileReady
                                        ? null
                                        : () async {
                                            log(files.isEmpty.toString());
                                            files = await filePicker(files);
                                            log(files.isEmpty.toString());
                                            if (files.isNotEmpty) {
                                              setState(() {
                                                fileReady = true;
                                              });
                                              var result = await FilesService()
                                                  .importFiles(
                                                      userData, files.first);
                                              log("inside result");
                                              if (result) {
                                                log("git");
                                                setStateModal(() {
                                                  fileFeedback =
                                                      "Plik został przesłany";
                                                });
                                              } else {
                                                setStateModal(() {
                                                  fileFeedback =
                                                      "Wystapil problem z importem pliku";
                                                });
                                              }
                                            }
                                            log("files ???");
                                          },
                                    child: const Icon(
                                      Icons.upload_file_outlined,
                                      size: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Importuj plik",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondColor,
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(40),
                                    ),
                                    onPressed: fileReady
                                        ? null
                                        : () async {
                                            setStateModal(() {
                                              fileStatus = true;

                                              log(progress.toString());
                                            });
                                            var export = exportFile("zip");
                                            if (export == true) {
                                              setStateModal(() {
                                                fileStatus = false;
                                              });
                                            }
                                          },
                                    child: const Icon(
                                      Icons.download,
                                      size: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Eksportuj plik",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 40,
                      ),
                      fileStatus
                          ? LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            )
                          : (Text(fileFeedback)),
                    ],
                  ))),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: deleteBtn,
                          foregroundColor: bgSmokedWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("Anuluj")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: bgSmokedWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          print("saved");
                          print("serverIP: $SERVER_IP");
                          Navigator.of(context).pop();
                        },
                        child: Text("Zapisz zmiany")),
                  ],
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(context, HeaderTitleType.settingsTitle),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
              child: ListView(children: [
                DashboardBox(
                    title: "O nas",
                    description: "Sekcja ta zawiera informacje o autorach",
                    onPressed: () async {
                      showAboutUsDialog();
                    },
                    assetImgPath: 'assets/aboutus.svg',
                    user: userData),
                const SizedBox(
                  height: 15,
                ),
                DashboardBox(
                    title: "Zmień hasło",
                    description:
                        "Twoje hasło nie jest w pełni bezpieczne? W tej sekcji zmienisz to w prosty sposób!",
                    onPressed: () async {
                      showChangePassDialog(
                          true,
                          "Zmień hasło",
                          "Zmień swoje hasło w 2 krokach",
                          "Podaj stare i nowe hasło",
                          "secLabel");
                    },
                    assetImgPath: 'assets/secure_login_pd4.svg',
                    user: userData),
                const SizedBox(
                  height: 15,
                ),
                DashboardBox(
                    title: "Zmień sposób walidacji",
                    description:
                        "Zmień sposób weryfikacji konta, wrazie gdybyś zapomniał swojego hasła.",
                    onPressed: () async {
                      print("val test2");
                    },
                    assetImgPath: 'assets/auth_pass.svg',
                    user: userData),
                const SizedBox(
                  height: 15,
                ),
                DashboardBox(
                    title: "Wyloguj się",
                    description:
                        "Przejście do tej sekcji spowoduje wylogowanie się z konta użytkownika",
                    onPressed: () async {
                      // print("val");
                      removeUserToken();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                      // Navigator.pop(context);
                      // Navigator.popUntil(
                      //     context, ModalRoute.withName('/user_auth'));
                    },
                    assetImgPath: 'assets/logout2.svg',
                    user: userData),
                const SizedBox(
                  height: 15,
                ),
                DashboardBox(
                    title: "Import / Eksport plików",
                    description:
                        "W tym miesjcu w prosty sposób zaimportujesz lub wyeksportujesz swoje dane!",
                    onPressed: () async {
                      importExportAlert();
                    },
                    assetImgPath: 'assets/exportimport.svg',
                    user: userData),
              ]))),
    );
  }
}
