import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';
import 'package:projzespoloey/pages/old_/_carList.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final storage = new FlutterSecureStorage();
  List brandList = [];
  List modelList = [];
  List transmissionList = [];
  List fuelTypeList = [];
  List drivetrainList = [];
  String? _selectedValue;
  String? brandItem;
  int? modelItem;
  String? fuelType;
  String? transmissionType;
  String? drivetrainType;
  int prodDate = DateTime.now().year;
  var selectedDate = DateTime.now();
  String? imgId = "";
  CarModelForm carItem = new CarModelForm(
      RokProdukcji: DateTime.now().year, DataZakupu: DateTime.now().toString());

  @override
  void initState() {
    super.initState();
    _getModeleMarki();
  }

  void _getModeleMarki() async {
    String? tokenVal = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(tokenVal));
    fuelTypeList = (await CarApiService().getFuelTypes(tokenVal));
    transmissionList = (await CarApiService().getTransmissionTypes(tokenVal));
    drivetrainList = (await CarApiService().getDrivetrainTypes(tokenVal));
    setState(() {});
  }

  void handleReadOnlyInputClick(context, String headerText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: mainColor, // header background color
              onPrimary: bgSmokedWhite, // header text color
              onSurface: Colors.black, // body text color
            )),
            child: AlertDialog(
              title: Text(headerText),
              content: Container(
                width: 100,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(1960),
                  lastDate: DateTime(DateTime.now().year),
                  selectedDate: DateTime(prodDate),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      prodDate = dateTime.year;
                      carItem.RokProdukcji = prodDate;
                      print("${prodDate}");
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ));
      },
    );
  }

  Future<void> _selectDate(BuildContext context, String headerText) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      cancelText: "ANULUJ",
      confirmText: "OK",
      helpText: "WYBIERZ DATĘ",
      initialDatePickerMode: DatePickerMode.year,
      initialDate: selectedDate,
      firstDate: DateTime(1960, 1),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor,
              onPrimary: fontWhite,
              onSurface: mainColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: mainColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Slider values
  double _currentGuaranteeSliderVal = 0;
  double _currentRefundSliderVal = 0;

  // Pick image
  File? image;
  /*Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      setState(() {
        this.image = imageTemp;
      });
      print(imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }*/

  Future pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      var imageTemp = File(result.files.single.path!);
      image = imageTemp;
      setState(() {
        image = imageTemp;
        imgId = image!.path.toString();
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    print(brandList);

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
        title: Text("Dodaj/Edytuj samochód"),
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
                                "Wprowadź dane samochodu",
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
                                "Marka samochodu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                value: brandItem,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    modelList = [];
                                    brandItem = value.toString();
                                    for (int i = 0; i < brandList.length; i++) {
                                      if (brandList[i]["nazwa"] == value) {
                                        modelList = brandList[i]["modeleMarki"];
                                      }
                                      modelItem = null;
                                    });
                                  },
                                  items: brandList.map((brand) {
                                    return DropdownMenuItem(
                                        value: brand['nazwa'],
                                        child: Text(brand['nazwa']));
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
                                      hintText: "Wybierz markę",
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
                                  "Model samochodu",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                                value: modelItem,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    modelItem = value as int?;
                                    carItem.IdModelu = modelItem!;
                                    print(modelItem);
                                  });
                                },
                                items: modelList.map((model) {
                                  return DropdownMenuItem(
                                      value: model['id'],
                                      child: Text(model['nazwa']));
                                }).toList(),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.car_crash_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wybierz model",
                                    fillColor: bg35Grey,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ))),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Data zakupu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () => handleReadOnlyInputClick(
                                          context, "Wybierz rok produkcji"),
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          hintText: "${prodDate.toString()}",
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
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    "Data zakupu",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    readOnly: true,
                                    onTap: () => _selectDate(
                                        context, "Wybierz datę zakupu"),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        hintText:
                                            "${selectedDate.toString().substring(0, 10)}",
                                        fillColor: bg35Grey,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide.none,
                                        )),
                                    /*validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'To pole nie może być puste';
                                          }
                                          return null;
                                        }*/
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              onSaved: (String? value) {
                                carItem.NumerVin = value;
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.numbers,
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Podaj numer VIN",
                                  fillColor: bg35Grey,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Pojemność silnika i numer rejestracyjny",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
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
                                      onSaved: (String? value) {
                                        carItem.PojemnoscSilnika =
                                            int.parse(value!);
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(1),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.abc,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Pojemność silnika",
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
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                        onSaved: (String? value) {
                                          carItem.NumerRejestracyjny = value;
                                        },
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(1),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.abc,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Pojemność silnika",
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
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Rodzaj paliwa i typ skrzyni biegów",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField(
                                      value: fuelType,
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          log(value.toString());
                                        });
                                      },
                                      items: fuelTypeList.map((fuels) {
                                        return DropdownMenuItem(
                                            value: fuels['id'],
                                            child: Text(
                                              fuels['nazwa'],
                                              style: TextStyle(fontSize: 12),
                                            ));
                                      }).toList(),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 0, 15, 0),
                                          prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons
                                                    .local_gas_station_outlined,
                                                color: fontBlack,
                                              )),
                                          hintText: "Rodzaj paliwa",
                                          hintStyle: TextStyle(fontSize: 11),
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField(
                                        value: brandItem,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            modelList = [];
                                            brandItem = value.toString();
                                            for (int i = 0;
                                                i < brandList.length;
                                                i++) {
                                              if (brandList[i]["nazwa"] ==
                                                  value) {
                                                modelList =
                                                    brandList[i]["modeleMarki"];
                                              }
                                            }
                                            modelItem = null;
                                          });
                                        },
                                        items: brandList.map((brand) {
                                          return DropdownMenuItem(
                                              value: brand['nazwa'],
                                              child: Text(brand['nazwa']));
                                        }).toList(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 15, 0),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 15, 5, 15),
                                              child: Image.asset(
                                                "assets/ico/manual-transmission.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            hintText: "Rodzaj skrzyni",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            ))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Przebieg i rodzaj napędu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
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
                                      onSaved: (String? value) {
                                        carItem.PojemnoscSilnika =
                                            int.parse(value!);
                                      },
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(1),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 5, 15),
                                            child: Image.asset(
                                              "assets/ico/counter.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                          hintText: "Przebieg pojazdu",
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
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField(
                                        value: brandItem,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            modelList = [];
                                            brandItem = value.toString();
                                            for (int i = 0;
                                                i < brandList.length;
                                                i++) {
                                              if (brandList[i]["nazwa"] ==
                                                  value) {
                                                modelList =
                                                    brandList[i]["modeleMarki"];
                                              }
                                            }
                                            modelItem = null;
                                          });
                                        },
                                        items: brandList.map((brand) {
                                          return DropdownMenuItem(
                                              value: brand['nazwa'],
                                              child: Text(brand['nazwa']));
                                        }).toList(),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 20, 0),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 5, 15),
                                              child: Image.asset(
                                                "assets/ico/all-wheel-drive.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            hintText: "Napęd",
                                            hintStyle: TextStyle(fontSize: 12),
                                            fillColor: bg35Grey,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            ))),
                                  ],
                                ),
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
                                    child: Text("Zdjęcie produktu"),
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
                                      print("test: $image");
                                      pickImage();
                                      //imgId = image!.path.toString();
                                      print("sciezka fotki");
                                      print(imgId);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              if (image != null) ...[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: secondaryColor,
                                        image: DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.scaleDown,
                                        ),
                                        border: Border.all(
                                            color: secondaryColor, width: 5)),
                                    width: 90,
                                    height: 90,
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
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: MediaQuery.of(context).viewInsets.bottom != 0
              ? const EdgeInsets.fromLTRB(0, 0, 0, 30)
              : EdgeInsets.zero,
          child: FloatingActionButton.extended(
            onPressed: () async {
              //print(formData);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String? tokenVal = await storage.read(key: "token");
                var id = await CarApiService().addCar(tokenVal, carItem);
                var uploadImg =
                    await CarApiService().uploadFile(tokenVal, imgId, id.body);
                // print(carItem);
                setState(() {
                  if (uploadImg) {
                    // Navigator.popAndPushNamed(context, "/carList", arguments: {
                    //   "module_data": "cars",
                    //   "user_auth": tokenVal,
                    //   "route_name": "cars"
                    // });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => CarList(),
                        ),
                        ModalRoute.withName("/dashboard"));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute<void>(
                    //       builder: (BuildContext context) => ,
                    //     ));
                    // Navigator.pop(context);
                  }
                });
                // Navigator.pop(context);
              }
            },
            backgroundColor: mainColor,
            label: Text("Zapisz pojazd"),
            icon: Icon(Icons.check),
          ),
        ),
        bottomSheet: MediaQuery.of(context).viewInsets.bottom > 150
            ? GestureDetector(
              onTap: () => print("CIPSKO"),
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: bg35Grey),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
            : SizedBox.shrink());
  }
}
