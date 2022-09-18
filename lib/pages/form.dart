import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projzespoloey/constants.dart';

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

class DataForm extends StatefulWidget {
  const DataForm({Key? key}) : super(key: key);

  @override
  State<DataForm> createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  Map data = {};
  Map headerText = {
    "add_receipt": "nowy paragon",
    "add_car": "nowy pojazd",
    "add_document": "nowy dokument",
    "add_home": "nowy sprzęt domowy"
  };

  Map formHeaderText = {
    "add_receipt": "produktu",
    "add_car": "pojazdu",
    "add_document": "dokumentu",
    "add_home": "sprzętu"
  };

  Map formType = {
    "form_car": "CarForm",
    "form_receipt": "ReceiptForm",
    "form_document": "DocumentForm",
    "form_home": "DocumentHome",
  };

  final _formKey = GlobalKey<FormState>();
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
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;

    print(image);
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
        title: Text("Dodaj ${headerText[data['form_type']]}"),
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
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                "Podaj dane ${formHeaderText[data['form_type']]}",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(10),
                                ),
                                onPressed: () {},
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Data zakupu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "00-00-0000",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Nazwa produktu",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.abc,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Podaj nazwę produktu",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Cena",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: TextFormField(
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.format_list_numbered,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "0,00",
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
                                    "Waluta",
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: TextFormField(
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.currency_exchange,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "PLN",
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
                                "Kategoria",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.category_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wybierz kategorię",
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
                                "Rodzaj i miejsce zakupu",
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
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(1),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.view_module_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Rodzaj zakupu",
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
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.fmd_good_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Nazwa sklepu",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                "Dodatkowe informacje",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            TextFormField(
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Wpisz swoje uwagi",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text("Okres gwarancji"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                "${_currentGuaranteeSliderVal.toInt()} miesięce",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackHeight: 10.0,
                                  trackShape: CustomTrackShape(),
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 15)),
                              child: Slider(
                                min: 0,
                                value: _currentGuaranteeSliderVal,
                                max: 60,
                                divisions: 5,
                                label: _currentGuaranteeSliderVal.toString(),
                                thumbColor: mainColor,
                                activeColor: main50Color,
                                inactiveColor: secondaryColor,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentGuaranteeSliderVal = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text("Okres zwrotu"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                "${_currentRefundSliderVal.toInt()} dni",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackHeight: 8.0,
                                  trackShape: CustomTrackShape(),
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 15)),
                              child: Slider(
                                min: 0,
                                max: 14,
                                divisions: 14,
                                value: _currentRefundSliderVal,
                                label: _currentRefundSliderVal.toString(),
                                thumbColor: mainColor,
                                activeColor: main50Color,
                                inactiveColor: secondaryColor,
                                onChanged: (double value) {
                                  setState(() {
                                    _currentRefundSliderVal = value;
                                  });
                                },
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
        onPressed: () {
          Navigator.pushNamed(context, "/form",
              arguments: {'form_type': 'add_receipt'});
        },
        backgroundColor: mainColor,
        label: Text(
            "Zapisz ${formHeaderText[data['form_type']].toString().substring(0, formHeaderText[data['form_type']].toString().length - 1)}"),
        icon: Icon(Icons.check),
      ),
    );
  }
}
