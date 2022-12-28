import 'dart:developer';
import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/receipts/receipt_model.dart';
import 'package:projzespoloey/pages/receiptsModule/receiptList.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/services/receipt/receipt_api_service.dart';
import 'package:projzespoloey/utils/photo_picker.dart';
import 'package:string_validator/string_validator.dart';

import '../../components/add_attachment_button.dart';
import '../../models/receipts/receipt_model_form.dart';
import '../../utils/date_picker.dart';

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

class ReceiptForm extends StatefulWidget {
  final bool isEditing;
  final String? receiptId;
  const ReceiptForm({Key? key, this.isEditing = false, this.receiptId})
      : super(key: key);

  @override
  State<ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<ReceiptForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  int purchaseDate = DateTime.now().year;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ReceiptModelForm receiptItem = ReceiptModelForm();
  List<PlatformFile> files = [];
  List categoryList = [];
  List dropdownCatList = [];
  List storesList = [];
  final _formKey = GlobalKey<FormState>();
  File? image;
  List receiptCategories = [];
  String? token;

  // Slider values
  double _currentGuaranteeSliderVal = 0;
  double _currentRefundSliderVal = 0;

  // late SingleValueDropDownController _cnt;

  // var dropdownlist;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    token = await storage.read(key: "token");
    categoryList = await ReceiptApiService().getCategories(token);
    if (widget.isEditing) {
      receiptItem = (await ReceiptApiService()
          .getReceiptFormData(token, widget.receiptId))!;
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  void showAddCarLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Zapisuję paragon...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(context, HeaderTitleType.receipt),
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                      "Podaj dane paragonu",
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
                                    padding:
                                        EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Nazwa produktu",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                      initialValue: receiptItem.nazwa,
                                      onSaved: (value) {
                                        receiptItem.nazwa = value;
                                      },
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.abc,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: receiptItem.nazwa ??
                                              "Podaj nazwę produktu",
                                          fillColor: bg35Grey,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Proszę podać nazwę produktu';
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                            initialValue:
                                                receiptItem.dataZakupu,
                                            readOnly: true,
                                            onTap: () async {
                                              DateTime? date =
                                                  await pickDate(context);
                                              setState(() {
                                                receiptItem.dataZakupu =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(date!);
                                              });
                                            },
                                            cursorColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                    Icons
                                                        .event_available_outlined,
                                                    color: Colors.black),
                                                contentPadding:
                                                    const EdgeInsets.all(15),
                                                hintText:
                                                    receiptItem.dataZakupu ??
                                                        "Wybierz datę",
                                                hintStyle: const TextStyle(
                                                    fontSize: 13),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                          "Kategoria produktu",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child:                                       DropdownButtonFormField(
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Wybierz kategorię dokumentu!';
                                              }
                                              return null;
                                            },
                                            value: receiptItem.idKategorii,
                                            isExpanded: true,
                                            onChanged: (value) {
                                              setState(() {
                                                receiptItem.idKategorii =
                                                value as int?;
                                              });
                                            },
                                            items: categoryList
                                                .map((category) {
                                              return DropdownMenuItem(
                                                  value: category['id'],
                                                  child: Text(category['nazwa']));
                                            }).toList(),
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    15, 10, 15, 15),
                                                prefixIcon: const Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 1),
                                                  child: Icon(
                                                    Icons.category_outlined,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                hintText: "Kategoria",
                                                hintStyle: TextStyle(fontSize: 14),
                                                fillColor: bg35Grey,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(50),
                                                  borderSide: BorderSide.none,
                                                )))
                                        ,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Text(
                                            "Cena",
                                            style: TextStyle(
                                              fontFamily: "Roboto",
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFormField(
                                              keyboardType: TextInputType
                                                  .numberWithOptions(),
                                              initialValue:
                                                  receiptItem.cena == null
                                                      ? ("")
                                                      : (receiptItem.cena
                                                          .toString()),
                                              onSaved: (value) {
                                                receiptItem.cena =
                                                    toDouble(value!);
                                              },
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  prefixIcon: const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .format_list_numbered,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: "0,00",
                                                  suffixText: "PLN",
                                                  suffixStyle:
                                                      TextStyle(fontSize: 13),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    toDouble(value).isNaN) {
                                                  return 'Proszę podać poprawną cenę produktu';
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                          "Nazwa sklepu",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: TextFormField(
                                          initialValue: receiptItem.nazwaSklepu,
                                          onSaved: (value) {
                                            receiptItem.nazwaSklepu = value;
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'To pole nie może być puste';
                                            }
                                            return null;
                                          },
                                          cursorColor: Colors.black,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              prefixIcon: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.fmd_good_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Nazwa sklepu",
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
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Text(
                                      "Dodatkowe informacje",
                                      style: TextStyle(
                                        fontFamily: "Roboto",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    initialValue: receiptItem.uwagi,
                                    onSaved: (value) {
                                      receiptItem.uwagi = value;
                                    },
                                    cursorColor: Colors.black,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        prefixIcon: const Padding(
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Text("Okres gwarancji"),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Text(
                                      "${_currentGuaranteeSliderVal.toInt()} dni ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        trackHeight: 10.0,
                                        trackShape: CustomTrackShape(),
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 15)),
                                    child: Slider(
                                      min: 0,
                                      value: _currentGuaranteeSliderVal,
                                      max: 730,
                                      divisions: 10,
                                      label:
                                          _currentGuaranteeSliderVal.toString(),
                                      thumbColor: mainColor,
                                      activeColor: main50Color,
                                      inactiveColor: secondaryColor,
                                      onChanged: (double value) {
                                        setState(() {
                                          _currentGuaranteeSliderVal = value;
                                          receiptItem.waznoscGwarancji =
                                              _currentGuaranteeSliderVal
                                                  .toInt();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Text("Okres zwrotu"),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: Text(
                                      "${_currentRefundSliderVal.toInt()} dni",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        trackHeight: 8.0,
                                        trackShape: CustomTrackShape(),
                                        thumbShape: const RoundSliderThumbShape(
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
                                          receiptItem.waznoscZwrotu =
                                              _currentRefundSliderVal.toInt();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (!widget.isEditing)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 25),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                              child: Text("Zdjęcie produktu"),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: secondaryColor,
                                                padding: image != null
                                                    ? const EdgeInsets.all(0)
                                                    : const EdgeInsets.all(35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
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
                                                            BorderRadius
                                                                .circular(25),
                                                        color: secondaryColor,
                                                        image: DecorationImage(
                                                          image:
                                                              FileImage(image!),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      width: 100,
                                                      height: 100,
                                                    )
                                                  : const Icon(
                                                      Icons
                                                          .add_a_photo_outlined,
                                                      size: 25,
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              if (!widget.isEditing)
                                AddAttachmentButton(
                                    formType: FormType.receipt,
                                    onChanged: (filesList) {
                                      files = filesList;
                                    })
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
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
                  log(_formKey.currentState!.validate().toString());
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {
                      isLoadingBtn = true;
                    });
                    showAddCarLoadingDialog(true);

                    if (!widget.isEditing) {
                      var id = await ReceiptApiService()
                          .addReceipt(token, receiptItem);
                      if (image != null) {
                        await FilesService()
                            .uploadFile(token, image!.path.toString(), id.body);
                      }
                      if (files.isNotEmpty) {
                        await FilesService().uploadFiles(token, files, id.body);
                      }
                    } else {
                      await ReceiptApiService()
                          .updateReceipt(token, receiptItem, widget.receiptId);
                      if (image != null) {
                        await FilesService().uploadFile(
                            token, image!.path.toString(), widget.receiptId);
                      }
                    }
                    setState(() {
                      showAddCarLoadingDialog(false);
                    });
                  }
                },
                backgroundColor: mainColor,
                label: Text(
                    widget.isEditing ? ("Zapisz paragon") : ("Dodaj paragon")),
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
          : const SizedBox.shrink(),
    );
  }
}
