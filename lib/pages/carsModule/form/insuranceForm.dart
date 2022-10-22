import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/main.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/constants.dart';

class InsuranceForm extends StatefulWidget {
  const InsuranceForm({Key? key}) : super(key: key);

  @override
  State<InsuranceForm> createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<InsuranceForm> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  var insuranceTypesList = [];
  String? dateFrom;
  String? dateTo;
  InsuranceFormModel insurance = InsuranceFormModel();
  Map item = {};
  List<PlatformFile> files = [];
  String? idSamochodu;

  void _getInsuranceTypes() async {
    String? tokenVal = await storage.read(key: "token");
    insuranceTypesList = (await CarApiService().getInsuranceTypes(tokenVal));
    Future.delayed(Duration(seconds: 0)).then((value) => setState(() {}));
  }

  Future<DateTime?> pickDate(context) {
    var date = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2023),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
            primary: mainColor, // header background color
            onPrimary: bgSmokedWhite, // header text color
            onSurface: Colors.black, // body text color
          )),
          child: child!,
        );
      },
    );
    return date;
  }

  Future pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        if (files.isNotEmpty) {
          files.clear();
        }
        //files = result.paths.map((path) => File(path!)).toList();
        files = result!.files;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        item = item.isNotEmpty
            ? item
            : ModalRoute.of(context)?.settings.arguments as Map;
        idSamochodu = item["idSamochodu"];
      });
    });

    _getInsuranceTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onPrimary: Colors.transparent,
            shadowColor: Colors.transparent,
            onSurface: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        foregroundColor: Colors.transparent,
        backgroundColor: secondaryColor,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
            fontSize: MediaQuery.of(context).textScaleFactor * 20,
            color: Colors.black),
        title: Text("Dodaj ubezpieczenie"),
      ),
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
                                "Wprowadź dane polisy",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
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
                                "Rodzaj ubezpieczenia",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                value: insurance.IdRodzajuUbezpieczenia,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    insurance.IdRodzajuUbezpieczenia =
                                        value as int?;
                                  });
                                },
                                items: insuranceTypesList.map((insurance) {
                                  return DropdownMenuItem(
                                      value: insurance['id'],
                                      child: Text(insurance['nazwa']));
                                }).toList(),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.car_repair,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wybierz rodzaj ubezpieczenia",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                              child: Text(
                                "Ubezpieczyciel",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              onSaved: (String? value) {
                                insurance.Ubezpieczyciel = value;
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
                                "Numer polisy",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                              onSaved: (String? value) {
                                insurance.NrPolisy = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.pin_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Podaj numer polisy",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    width: 145,
                                    child: TextFormField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                              await pickDate(context);
                                          setState(() {
                                            insurance.DataZakupu =
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
                                                insurance.DataZakupu ?? "Od",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (date) {
                                          if (insurance.DataZakupu == null) {
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
                                      width: 145,
                                      child: TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? date =
                                                await pickDate(context);
                                            setState(() {
                                              insurance.DataKonca =
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
                                                  insurance.DataKonca ?? "Do",
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
                                            if (insurance.DataKonca == null) {
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextFormField(
                                onSaved: (String? value) {
                                  insurance.KosztPolisy = double.parse(value!);
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text("Załączniki"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: secondaryColor,
                                      onPrimary: second50Color,
                                      padding: EdgeInsets.all(40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                    ),
                                    onPressed: () {
                                      pickFiles();
                                      print("TEST LISTY PLIKOW");
                                      print(files);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (files.isNotEmpty) ...[
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  width: 230,
                                  child: ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(
                                                height: 0,
                                                color: Colors.transparent,
                                              ),
                                      itemCount: files!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final file = files[index];
                                        return GestureDetector(
                                          onTap: () {
                                            //_download("$SERVER_IP/api/fileUpload/GetFile/${_files![index].idPliku}?naglowkowy=false");
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.all(5),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            shadowColor: fontBlack,
                                            child: ListTile(
                                              leading: Icon(Icons.abc),
                                              title: Text(
                                                file.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              tileColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(insurance.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? tokenVal = await storage.read(key: "token");
            var insuranceId = await CarApiService()
                .addInsurance(tokenVal, insurance, idSamochodu);
            await CarApiService().uploadFiles(tokenVal, files, insuranceId);
            Navigator.pop(context);
          }
        },
        backgroundColor: mainColor,
        label: Text("Dodaj ubezpieczenie"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
