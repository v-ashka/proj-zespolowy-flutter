import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/home_model.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/services/home_service.dart';
import 'package:projzespoloey/utils/photo_picker.dart';

class HomeForm extends StatefulWidget {
  final String? homeId;
  final bool isEditing;
  final HomeModel? editModel;

  const HomeForm(
      {Key? key, this.homeId, this.isEditing = false, this.editModel})
      : super(key: key);

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkIfEditForm(widget.isEditing, widget.editModel);
    getData();
  }

  HomeModel home = HomeModel();
  List<PlatformFile> files = [];
  File? image;
  List homeTypes = [];
  bool isLoading = true;
  String? token = "";
  int moveInDate = DateTime.now().year;

  void yearPicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: mainColor, // header background color
              onPrimary: bgSmokedWhite, // header text color
              onSurface: Colors.black, // body text color
            )),
            child: AlertDialog(
              title: const Text("Wybierz rok zamieszkania"),
              content: SizedBox(
                width: 100,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960),
                  lastDate: DateTime(DateTime.now().year),
                  selectedDate: DateTime(moveInDate),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      moveInDate = dateTime.year;
                      home.rokWprowadzenia = moveInDate.toString();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
      },
    );
  }

  void showAddHomeDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Zapisuję dom...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeList(),
          ),
          ModalRoute.withName("/dashboard"));
    }
  }

  void getData() async {
    token = await storage.read(key: "token");
    homeTypes = await HomeService().getHomeTypes(token);
    if (widget.isEditing) {
      //carItem = await CarApiService().getCarFormData(token, widget.carId);
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  void checkIfEditForm(isEdit, editModel) async {
    if (isEdit) {
      home = editModel;
    }
  }

  Future pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        if (files.isNotEmpty) {
          files.clear();
        }
        files = result.files;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing
              ? (HeaderTitleType.formEditHome)
              : (HeaderTitleType.formAddHome)),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      // padding: EdgeInsets.only(bottom: 10),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 12,
                              child: Text(
                                "Wprowadź dane domu",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text(
                                "Wybierz rodzaj domu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) {
                                    return 'Proszę wybrać rodzaj domu!';
                                  }
                                  return null;
                                },
                                value: home.idTypDomu,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    home.idTypDomu = value as int;
                                  });
                                },
                                items: homeTypes.map((type) {
                                  return DropdownMenuItem(
                                      value: type['id'],
                                      child: Text("${type["nazwa"]}"));
                                }).toList(),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.home_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wybierz rodzaj domu",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ))),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Ulica i numer domu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                initialValue: home.ulicaNrDomu ?? "",
                                onSaved: (String? value) {
                                  home.ulicaNrDomu = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.signpost_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Ulica i numer domu",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'To pole nie może być puste';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 325,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Kod pocztowy",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Miejscowość",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          initialValue: home.kodPocztowy ?? "",
                                          onSaved: (String? value) {
                                            home.kodPocztowy = value;
                                          },
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.all(1),
                                              prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons
                                                      .local_post_office_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Kod pocztowy",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
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
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          }),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                            initialValue:
                                                home.miejscowosc ?? "",
                                            onSaved: (String? value) {
                                              home.miejscowosc = value;
                                            },
                                            cursorColor: Colors.black,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(15),
                                                prefixIcon: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1),
                                                  child: Icon(
                                                    Icons.location_city_rounded,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                hintText: "Miejscowość",
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
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
                                                return 'To pole nie może być puste';
                                              }
                                              return null;
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Rok zamieszkania",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () => yearPicker(context),
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                              Icons.event_outlined,
                                              color: Colors.black),
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          hintText: home.rokWprowadzenia != null
                                              ? home.rokWprowadzenia.toString()
                                              : "Wybierz rok",
                                          hintStyle: home.rokWprowadzenia !=
                                                  null
                                              ? const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)
                                              : const TextStyle(fontSize: 14),
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    "Liczba pokoi",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  child: TextFormField(
                                      initialValue: home.liczbaPokoi,
                                      onSaved: (String? value) {
                                        home.liczbaPokoi = value;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 1, 20, 1),
                                          prefixIcon: const Icon(
                                              Icons.door_back_door_outlined,
                                              color: Colors.black),
                                          hintText: "Liczba pokoi",
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste';
                                        }
                                        return null;
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 325,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Powierzchnia domu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                              if (home.idTypDomu == 1)
                                Text(
                                  "Powierzchnia działki",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                      initialValue: home.powierzchniaDomu,
                                      onSaved: (String? value) {
                                        home.powierzchniaDomu = value;
                                      },
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          suffixText: "m2",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.square_foot_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Powierzchnia domu",
                                          hintStyle: TextStyle(fontSize: 12),
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste';
                                        }
                                        return null;
                                      }),
                                ],
                              ),
                            ),
                            if (home.idTypDomu == 1)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          initialValue:
                                              home.powierzchniaDzialki,
                                          onSaved: (String? value) {
                                            home.powierzchniaDzialki = value;
                                          },
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(15),
                                              suffixText: "ar",
                                              prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.area_chart_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Powierzchnia działki",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
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
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!widget.isEditing) ...[
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Text("Zdjęcie domu"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: secondaryColor,
                                        padding: image != null
                                            ? const EdgeInsets.all(0)
                                            : const EdgeInsets.all(35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      onPressed: () async {
                                        image = await pickImage();
                                        setState(() {
                                          image;
                                        });
                                      },
                                      child: image != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: secondaryColor,
                                                image: DecorationImage(
                                                  image: FileImage(image!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              width: 100,
                                              height: 100,
                                            )
                                          : const Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 25,
                                              color: Colors.black),
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 25),
                                    if (image == null) ...[
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondColor,
                                            foregroundColor: bgSmokedWhite,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          onPressed: () async {
                                            image = await pickImage();
                                            setState(() {
                                              image;
                                            });
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(Icons.image_outlined),
                                              SizedBox(width: 2),
                                              Text("Zmień zdjęcie domu",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ))
                                    ] else ...[
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: secondaryColor,
                                            padding: image != null
                                                ? const EdgeInsets.all(0)
                                                : const EdgeInsets.all(35),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          onPressed: () async {
                                            image = await pickImage();
                                            setState(() {
                                              image;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: secondaryColor,
                                              image: DecorationImage(
                                                image: FileImage(image!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width: 100,
                                            height: 100,
                                          )),
                                    ]
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!widget.isEditing!) ...[
                          AddAttachmentButton(
                              //files: files,
                              formType: FormType.home,
                              onChanged: (filesList) {
                                files = filesList;
                              })
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // print(inspection.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            showAddHomeDialog(true);
            String? token = await storage.read(key: "token");
            if (!widget.isEditing) {
              Response? response = await HomeService().addHome(home, token);
              if (files.isNotEmpty && response?.statusCode == 200 ||
                  response?.statusCode == 202) {
                await FilesService().uploadFiles(token, files, response?.data);
                if (image != null) {
                  await FilesService().uploadFile(
                      token, image!.path.toString(), response?.data);
                }
              }
            } else {
              await HomeService()
                  .updateHome(home, token, widget.editModel!.idDomu);
            }
          }
          setState(() {
            showAddHomeDialog(false);
          });
        },
        backgroundColor: mainColor,
        label: Text(widget.isEditing! ? ("Zapisz dom") : ("Dodaj dom")),
        icon: Icon(Icons.check),
      ),
    );
  }
}
