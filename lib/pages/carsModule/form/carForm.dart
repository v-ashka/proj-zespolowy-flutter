import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';

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
  String? _selectedValue;
  String? brandItem;
  int? modelItem;
  String? _selectedValue2;
  int? _selectedValue3;
  List<String> selectType = [
    "Audi",
    "BMW",
    "Peugeot",
    "Skoda",
    "Renault",
  ];

  List<String> selectType2 = [
    "A4",
    "E36",
    "106",
    "Fabia",
    "Megane",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getModeleMarki();
  }

  void _getModeleMarki() async {
    String? tokenVal = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(tokenVal));
    Future.delayed(Duration(seconds: 0)).then((value) => setState(() {}));
  }


  void handleReadOnlyInputClick(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: mainColor, // header background color
              onPrimary: bgSmokedWhite, // header text color
              onSurface: Colors.black, // body text color
            )),
            child: AlertDialog(
          title: Text("Wybierz rok produkcji"),
          content: Container(
            // Need to use container to add size constraint.
            width: 100,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1960),
              lastDate: DateTime(DateTime.now().year),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: DateTime(prodDate),
              onChanged: (DateTime dateTime) {
                // close the dialog when year is selected.
                Navigator.pop(context);
                setState(() {
                  prodDate = dateTime.year;
                  print("${prodDate}");
                });

                // Do something with the dateTime selected.
                // Remember that you need to use dateTime.year to get the year
              },
            ),
          ),
        ));
      },
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDatePickerMode: DatePickerMode.year,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  final _formKey = GlobalKey<FormState>();
  String? engineCapacity = '';
  int prodDate = DateTime.now().year;
  String? vin = "";
  String? purchaseDate = "";
  String? regNr = "";
  String? imgId = "";
  String? model = "";
  String? brand = "";

  // Slider values
  double _currentGuaranteeSliderVal = 0;
  double _currentRefundSliderVal = 0;

  // Pick image
  File? image;
  Future pickImage() async {
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
  }

  @override
  Widget build(BuildContext context) {
    Map formData = {
      "pojemnoscSilnika": engineCapacity,
      "rokProdukcji": prodDate,
      "numerVin": vin,
      "dataZakupu": DateTime.now().toString(),
      "numerRejestracyjny": regNr,
      "modelId": modelItem,
      "idZdjecia": "string"
    };
    Map formData1 = {
      "pojemnoscSilnika": "string",
      "rokProdukcji": "string",
      "numerVin": "string",
      "dataZakupu": DateTime.now().toString(),
      "numerRejestracyjny": "string",
      "modelId": 10,
      "idZdjecia": "string"
    };
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
                                      if (brandList[i]["name"] == value) {
                                        modelList = brandList[i]["modeleMarki"];
                                      }
                                    }
                                    modelItem = null;
                                  });
                                },
                                items: brandList.map((brand) {
                                  return DropdownMenuItem(
                                      value: brand['name'],
                                      child: Text(brand['name']));
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
                            /*DropdownButtonFormField(
                                          value: _selectedValue2,
                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue2 = value.toString();
                                            });
                                          },
                                          onSaved: (value) {
                                            setState(() {
                                              _selectedValue2 = value.toString();
                                            });
                                          },
                                          items: selectType2.map((String val) {
                                            return DropdownMenuItem(
                                                value: val, child: Text(val));
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
                                    )))*/
                            DropdownButtonFormField(
                                value: modelItem,
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    modelItem = value as int?;
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
                                      "Rok produkcji",
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
                                        onTap: () =>
                                            handleReadOnlyInputClick(context),
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            hintText: "${prodDate.toString()}",
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
                                      onSaved: (String? value) {
                                        purchaseDate = value;
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: "0000-00-00",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Numer VIN",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                onSaved: (String? value) {
                                  vin = value;
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'To pole nie może być puste';
                                  }
                                  return null;
                                }),
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
                                        engineCapacity = value;
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
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                        onSaved: (String? value) {
                                          regNr = value;
                                        },
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons
                                                    .format_list_numbered_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Numer rej.",
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
                                      imgId = image.toString();
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
                            if (image != null) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(formData);
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String? tokenVal = await storage.read(key: "token");
            await CarApiService().addCar(tokenVal, formData);
            Navigator.pop(context);
          }
        },
        backgroundColor: mainColor,
        label: Text("Zapisz pojazd"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
