import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/pages/documentsModule/documentsList.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/date_picker.dart';
import 'package:file_picker/file_picker.dart';

class DocumentForm extends StatefulWidget {
  final bool isEditing;
  final DocumentModel? document;

  const DocumentForm({Key? key, this.isEditing = false, this.document})
      : super(key: key);

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  final _formKey = GlobalKey<FormState>();
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
    documentCategories = (await DocumentService().getCategories(token));
    if (widget.isEditing) {
      document = widget.document!;
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  void showAddDocumentLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Zapisuję dokument...'),
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
            builder: (BuildContext context) => const DocumentsList(),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 5),
                                      child: Text(
                                        "Nazwa dokumentu",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue:
                                          document.nazwaDokumentu ?? "",
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
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            borderSide: BorderSide.none,
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                              document.kategoria =
                                                  value as int?;
                                            });
                                          },
                                          items: documentCategories
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
                                              hintText: "Wybierz kategorię",
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide.none,
                                              )))
                                    ]),
                                if (document.kategoria == null)
                                  const SizedBox(height: 15),
                                if (document.kategoria == 1) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Ubezpieczyciel",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        initialValue:
                                            document.ubezpieczyciel ?? "",
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              borderSide: BorderSide.none,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Koszt polisy",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
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
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: Icon(
                                                  Icons.attach_money_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              hintText: "Podaj koszt polisy",
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
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 5),
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1),
                                                      child: Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    hintText:
                                                        document.dataStartu ??
                                                            "Od",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    fillColor: bg35Grey,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          BorderSide.none,
                                                    )),
                                                validator: (date) {
                                                  if (document.dataStartu ==
                                                      null) {
                                                    return 'To pole nie może być puste';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 26, 0, 5),
                                            child: SizedBox(
                                              width: 160,
                                              child: TextFormField(
                                                  readOnly: true,
                                                  onTap: () async {
                                                    DateTime? date =
                                                        await pickDate(context);
                                                    setState(() {
                                                      document.dataKonca =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(date!);
                                                    });
                                                  },
                                                  cursorColor: Colors.black,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      hintText:
                                                          document.dataKonca ??
                                                              "Do",
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      fillColor: bg35Grey,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        borderSide:
                                                            BorderSide.none,
                                                      )),
                                                  validator: (date) {
                                                    if (document.dataKonca ==
                                                        null) {
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
                                ],
                                if (document.kategoria == 2) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 0, 5),
                                            child: Text(
                                              "Okres trwania umowy",
                                              style: TextStyle(
                                                fontFamily: "Roboto",
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 175,
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    prefixIcon: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1),
                                                      child: Icon(
                                                        Icons
                                                            .calendar_today_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    hintText:
                                                        document.dataStartu ??
                                                            "Od",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    fillColor: bg35Grey,
                                                    filled: true,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          BorderSide.none,
                                                    )),
                                                validator: (date) {
                                                  if (document.dataStartu ==
                                                      null) {
                                                    return 'To pole nie może być puste';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 26, 0, 5),
                                            child: SizedBox(
                                              width: 175,
                                              child: TextFormField(
                                                  readOnly: true,
                                                  onTap: () async {
                                                    DateTime? date =
                                                        await pickDate(context);
                                                    setState(() {
                                                      document.dataKonca =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(date!);
                                                    });
                                                  },
                                                  cursorColor: Colors.black,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                      prefixIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      hintText:
                                                          document.dataKonca ??
                                                              "Do",
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      fillColor: bg35Grey,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        borderSide:
                                                            BorderSide.none,
                                                      )),
                                                  validator: (date) {
                                                    if (document.dataKonca ==
                                                        null) {
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
                                ],
                                if (document.kategoria == 3) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Wystawca faktury",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        initialValue:
                                            document.sprzedawcaNaFakturze ?? "",
                                        onSaved: (String? value) {
                                          document.sprzedawcaNaFakturze = value;
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
                                            hintText:
                                                "Wprowadź wystawcę faktury",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Numer faktury",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        initialValue:
                                            document.numerFaktury ?? "",
                                        onSaved: (String? value) {
                                          document.numerFaktury = value;
                                        },
                                        cursorColor: Colors.black,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(15),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(top: 1),
                                              child: Icon(
                                                Icons.numbers_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText: "Podaj numer faktury",
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data wystawienia faktury",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Wartość faktury",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? date =
                                                    await pickDate(context);
                                                setState(() {
                                                  document.dataWystawienia =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date!);
                                                });
                                              },
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: document
                                                          .dataWystawienia ??
                                                      "Data wystawienia faktury",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
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
                                                      document.wartoscFaktury,
                                                  onSaved: (String? value) {
                                                    document.wartoscFaktury = value;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(1),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1),
                                                        child: Icon(
                                                          Icons
                                                              .attach_money_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      hintText:
                                                          "Wartość faktury",
                                                      hintStyle: TextStyle(
                                                          fontSize: 12),
                                                      fillColor: bg35Grey,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        borderSide:
                                                            BorderSide.none,
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
                                if (document.kategoria == 4) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data wystawienia",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 75),
                                          child: Text(
                                            "Wysokość rachunku",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextFormField(
                                              readOnly: true,
                                              onTap: () async {
                                                DateTime? date =
                                                    await pickDate(context);
                                                setState(() {
                                                  document.dataWystawienia =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(date!);
                                                });
                                              },
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  hintText: document
                                                          .dataWystawienia ??
                                                      "Data wystawienia rachunku",

                                                      hintStyle: TextStyle(fontSize: document.dataPrzypomnienia != null ? 14 : 13, color: document.dataPrzypomnienia != null ? Colors.black : Colors.black54),
                                                  fillColor: bg35Grey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    borderSide: BorderSide.none,
                                                  )),
                                            ),
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
                                                      document.wysokoscRachunku,
                                                  onSaved: (String? value) {
                                                    document.wysokoscRachunku = value;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(1,1,15,1),
                                                      prefixIcon: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 1),
                                                        child: Icon(
                                                          Icons
                                                              .attach_money_outlined,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      hintText: "Rachunek",
                                                      suffixText: "zł",
                                                      hintStyle: TextStyle(
                                                          fontSize: 13),
                                                      fillColor: bg35Grey,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        borderSide:
                                                            BorderSide.none,
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
                                if (document.kategoria == 4 ||
                                    document.kategoria == 5) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Data przypomnienia",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? date =
                                              await pickDate(context);
                                          setState(() {
                                            document.dataPrzypomnienia =
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
                                                Icons.calendar_month_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            hintText:
                                                document.dataPrzypomnienia ??
                                                    "Ustaw datę przypomnienia",
                                            hintStyle: TextStyle(color: document.dataPrzypomnienia != null ? Colors.black : Colors.black54),
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
                                ],
                                if (document.kategoria != null) ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Text(
                                          "Opis dokumentu",
                                          style: TextStyle(
                                            fontFamily: "Roboto",
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 15),
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
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              hintText:
                                                  "Dodaj opis do dokumentu...",
                                              fillColor: bg35Grey,
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide.none,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if(!widget.isEditing && document.kategoria != null)...[
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
                      });
                      showAddDocumentLoadingDialog(true);
                    }
                    if (!widget.isEditing) {
                      var id =
                          await DocumentService().addDocument(token, document);
                    } else {
                      await DocumentService().updateDocument(
                          token, document, document.idDokumentu);
                    }
                    setState(() {
                      showAddDocumentLoadingDialog(false);
                    });
                  },
                  backgroundColor: mainColor,
                  label: Text(widget.isEditing
                      ? ("Zapisz dokument")
                      : ("Dodaj dokument")),
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
