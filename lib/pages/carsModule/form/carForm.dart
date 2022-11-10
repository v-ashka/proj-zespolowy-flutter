import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  String? _selectedValue;
  String? brandItem;
  int? modelItem;
  int prodDate = DateTime.now().year;
  String? imgId = "";
  CarModelForm carItem = CarModelForm(
      RokProdukcji: DateTime.now().year,
      DataZakupu: DateTime.now().toString().substring(0, 10));
  final _formKey = GlobalKey<FormState>();
  File? image;

  @override
  void initState() {
    super.initState();
    _getModeleMarki();
  }

  void _getModeleMarki() async {
    String? tokenVal = await storage.read(key: "token");
    brandList = (await CarApiService().getModeleMarki(tokenVal));
    setState(() {});
  }

  void handleReadOnlyInputClick(context) {
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
              title: Text("Wybierz rok produkcji"),
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

  Future<DateTime?> pickDate(context) {
    var date = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2026),
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
            child: const Icon(
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
          title: const Text("Dodaj samochód"),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
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
                            children: const [
                              Expanded(
                                flex: 12,
                                child: Text(
                                  "Wprowadź dane samochodu",
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
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                child: Text(
                                  "Marka samochodu",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Wybierz markę pojazdu!';
                                    }
                                    return null;
                                  },
                                  value: brandItem,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      modelList = [];
                                      brandItem = value.toString();
                                      for (int i = 0;
                                          i < brandList.length;
                                          i++) {
                                        if (brandList[i]["nazwa"] == value) {
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
                              DropdownButtonFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Wybierz model pojazdu!';
                                    }
                                    return null;
                                  },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      width: 160,
                                      child: TextFormField(
                                        readOnly: true,
                                        onTap: () =>
                                            handleReadOnlyInputClick(context),
                                        cursorColor: Colors.black,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            hintText:
                                                carItem.RokProdukcji.toString(),
                                            hintStyle: const TextStyle(
                                                color: Colors.black),
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
                                    width: 160,
                                    child: TextFormField(
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? date =
                                            await pickDate(context);
                                        setState(() {
                                          carItem.DataZakupu =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(date!);
                                        });
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          hintText: carItem.DataZakupu,
                                          hintStyle: const TextStyle(
                                              color: Colors.black),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'To pole nie może być puste';
                                    }
                                    if (value.length != 17) {
                                      return 'Numer VIN musi składać się z 17 znaków! ';
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
                                          carItem?.PojemnoscSilnika =
                                              int.parse(value!);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          onSaved: (String? value) {
                                            carItem?.NumerRejestracyjny = value;
                                          },
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              prefixIcon: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons
                                                      .format_list_numbered_rounded,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Numer rej.",
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
