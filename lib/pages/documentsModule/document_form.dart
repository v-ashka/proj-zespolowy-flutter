import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/date_picker.dart';
import 'package:projzespoloey/utils/photo_picker.dart';
import 'package:file_picker/file_picker.dart';

class DocumentForm extends StatefulWidget {
  final bool isEditing;
  final String? carId;
  final String? brand;
  final String? make;

  const DocumentForm(
      {Key? key, this.isEditing = false, this.carId, this.brand, this.make})
      : super(key: key);

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  List brandList = [];
  List modelList = [];
  List transmissionList = [];
  List fuelTypeList = [];
  List drivetrainList = [];
  int? fuelType;
  int? transmissionType;
  int? drivetrainType;
  String? brandItem;
  int? modelItem;
  int prodDate = DateTime.now().year;
  String? imgId = "";
  CarModelForm carItem = CarModelForm();
  final _formKey = GlobalKey<FormState>();
  File? image;
  int? transmission;
  String? token;
  List documentCategories = [];
  DocumentModel document = DocumentModel();
  List<PlatformFile> files = [];


  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(token));
    documentCategories = (await DocumentService().getCategories(token));
    fuelTypeList = (await CarApiService().getFuelTypes(token));
    transmissionList = (await CarApiService().getTransmissionTypes(token));
    drivetrainList = (await CarApiService().getDrivetrainTypes(token));
    if (widget.isEditing) {
      carItem = await CarApiService().getCarFormData(token, widget.carId);
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

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
              title: const Text("Wybierz rok produkcji"),
              content: SizedBox(
                width: 100,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960),
                  lastDate: DateTime(DateTime.now().year),
                  selectedDate: DateTime(prodDate),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      prodDate = dateTime.year;
                      carItem.rokProdukcji = prodDate.toString();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
      },
    );
  }

  void showAddCarLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Zapisuję pojazd...'),
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
            builder: (BuildContext context) => const CarList(),
          ),
          ModalRoute.withName("/dashboard"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: myAppBar(
            context,
            widget.isEditing
                ? (HeaderTitleType.formEditDocument)
                : (HeaderTitleType.formAddDocument)),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                      strokeWidth: 5,
                    ),
                    heightFactor: 15,
                  )
                      : Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Column(
                        // padding: EdgeInsets.only(bottom: 10),
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Expanded(
                                flex: 12,
                                child: Text(
                                  "Wprowadź dane dokumentu",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                                child: Text(
                                  "Nazwa dokumentu",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              TextFormField(
                                initialValue: document.nazwaDokumentu ?? "",
                                onSaved: (String? value) {
                                  document.nazwaDokumentu = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.business_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wprowadź nazwę",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  "Kategoria dokumentu",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                                DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Wybierz kategorię dokumentu!';
                                      }
                                      return null;
                                    },
                                    value: document.kategoria,
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        document.kategoria = value as int?;
                                      });
                                    },
                                    items: documentCategories.map((category) {
                                      return DropdownMenuItem(
                                          value: category['id'],
                                          child: Text(category['nazwa']));
                                    }).toList(),
                                    decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(15, 10, 15, 15),
                                        prefixIcon: const Padding(
                                          padding:
                                          EdgeInsets.only(top: 1),
                                          child: Icon(
                                            Icons.category_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Wybierz kategorię",
                                        fillColor: bg35Grey,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          borderSide: BorderSide.none,
                                        )))
                                      ]),
                        if(document.kategoria == null)
                          const SizedBox(height: 15),
                        if(document.kategoria == 1)...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Ubezpieczyciel",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              initialValue: document.ubezpieczyciel ?? "",
                              onSaved: (String? value) {
                                document.ubezpieczyciel = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.business_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Nazwa ubezpieczyciela",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  "Koszt polisy",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFormField(
                                  initialValue: widget.isEditing
                                      ? (document.wartoscPolisy)
                                      : (''),
                                  keyboardType: TextInputType.number,
                                  onSaved: (String? value) {
                                    document.wartoscPolisy = value;
                                  },
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      suffixText: "zł",
                                      contentPadding:
                                      EdgeInsets.fromLTRB(
                                          10, 1, 20, 1),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(top: 1),
                                        child: Icon(
                                          Icons.attach_money_outlined,
                                          color: Colors.black,
                                        ),
                                      ),
                                      hintText: "Podaj koszt polisy",
                                      fillColor: bg35Grey,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Okres ubezpieczenia",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: TextFormField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                          await pickDate(context);
                                          setState(() {
                                            document.dataStartu =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(date!);
                                          });
                                        },
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText:
                                            document.dataStartu ?? "Od",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (date) {
                                          if (document.dataStartu == null) {
                                            return 'To pole nie może być puste';
                                          }
                                          return null;
                                        }),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(12, 26, 0, 5),
                                    child: SizedBox(
                                      width: 160,
                                      child: TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? date =
                                            await pickDate(context);
                                            setState(() {
                                              document.dataKonca =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(date!);
                                            });
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              prefixIcon: const Padding(
                                                padding:
                                                EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              contentPadding:
                                              const EdgeInsets.all(15),
                                              hintText:
                                              document.dataKonca ?? "Do",
                                              hintStyle:
                                              TextStyle(fontSize: 12),
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )),
                                          validator: (date) {
                                            if (document.dataKonca == null) {
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  "Opis dokumentu",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: TextFormField(
                                  initialValue: document.opis ?? "",
                                  maxLines: 4,
                                  onSaved: (String? value) {
                                    document.opis = value;
                                  },
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      hintText: "Dodaj opis do dokumentu...",
                                      fillColor: bg35Grey,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          ],
                          if (!widget.isEditing! && document.kategoria != null) ...[
                            AddAttachmentButton(
                              //files: files,
                                formType: FormType.document,
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
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        floatingActionButton: isLoadingBtn
            ? (const SizedBox.shrink())
            : Padding(
          padding: MediaQuery.of(context).viewInsets.bottom != 0
              ? const EdgeInsets.fromLTRB(0, 0, 0, 30)
              : EdgeInsets.zero,
          child: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  isLoadingBtn = true;
                  carItem.rokProdukcji ??= DateTime.now().year.toString();
                  carItem.dataZakupu ??=
                      DateTime.now().toString().substring(0, 10);
                });
                showAddCarLoadingDialog(true);
              }
              if (!widget.isEditing) {
                var id =
                await CarApiService().addCar(token, carItem);
                if (image != null) {
                  await FilesService().uploadFile(
                      token, image!.path.toString(), id.body);
                }
              } else {
                await CarApiService()
                    .updateCar(token, carItem, widget.carId);
                if (image != null) {
                  await FilesService().uploadFile(
                      token, image!.path.toString(), widget.carId);
                }
              }
              setState(() {
                showAddCarLoadingDialog(false);
              });
            },
            backgroundColor: mainColor,
            label: Text(
                widget.isEditing ? ("Zapisz pojazd") : ("Dodaj pojazd")),
            icon: const Icon(Icons.check),
          ),
        ),
        bottomSheet: MediaQuery.of(context).viewInsets.bottom > 150
            ? GestureDetector(
          onTap: () => {},
          child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: bg35Grey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_outlined),
                  SizedBox(width: 10),
                  Text(
                    "Zeskanuj",
                    style: TextStyle(
                        fontFamily: 'Lato', fontWeight: FontWeight.w600),
                  )
                ],
              )),
        )
            : const SizedBox.shrink());
  }
}
