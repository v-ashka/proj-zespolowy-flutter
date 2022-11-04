import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/pages/carsModule/carItem.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/services/car/insurance_service.dart';
import 'package:projzespoloey/services/car/inspection_service.dart';

class ServiceForm extends StatefulWidget {
  const ServiceForm({Key? key}) : super(key: key);

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  Map item = {};
  var serviceStatus = [
    {"title": "aktualny", "status": true},
    {"title": "nieaktualny", "status": false}
  ];

  ServiceFormModel service = ServiceFormModel();
  List<PlatformFile> files = [];

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
  Widget build(BuildContext context) {
    item = item.isNotEmpty
        ? item
        : ModalRoute.of(context)?.settings.arguments as Map;
    print(item);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
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
        title: Text("Dodaj nowy przegląd"),
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
                                "Status przeglądu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                value: service.CzyPozytywny,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    service.CzyPozytywny = value as bool;
                                  });
                                },
                                items: serviceStatus.map((service) {
                                  return DropdownMenuItem(
                                      value: service['status'],
                                      child: Text("${service["title"]}"));
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Data zatwierdzenia przeglądu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                              await pickDate(context);
                                          setState(() {
                                            service.DataPrzegladu =
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
                                            hintText: service.DataPrzegladu ??
                                                "Data zatwierdzenia",
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                        validator: (date) {
                                          if (service.DataPrzegladu == null) {
                                            return 'To pole nie może być puste';
                                          }
                                          return null;
                                        }),
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
                                "Uwagi do przeglądu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: TextFormField(
                                maxLines: 4,
                                onSaved: (String? value) {
                                  service.Uwagi = value;
                                },
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    hintText: "Dodaj uwagi do przeglądu...",
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
                                            shadowColor: Colors.white,
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
          print(service.toJson());
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? tokenVal = await storage.read(key: "token");
            var insuranceId = await InspectionApiService()
                .addService(tokenVal, service, item["idSamochodu"]);
            var uploadImg =
                await CarApiService().uploadFiles(tokenVal, files, insuranceId);
            setState(() {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        CarItem(carId: item["idSamochodu"]!),
                  ),
                  ModalRoute.withName('/dashboard'));
              // Navigator.pop(context);
            });
          }
        },
        backgroundColor: mainColor,
        label: Text("Dodaj przegląd"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
