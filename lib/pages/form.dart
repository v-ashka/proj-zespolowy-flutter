import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
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
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 5, 0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text("Data zakupu"),
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
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text("Nazwa produktu"),
                          ),
                          TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
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
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Cena"),
                                ),
                                TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
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
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Waluta"),
                                ),
                                TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text("Kategoria"),
                          ),
                          TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
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
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Rodzaj i miejsce zakupu"),
                                ),
                                TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(top: 1),
                                          child: Icon(
                                            Icons.view_module_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Rodzaj zakupu",
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(""),
                                ),
                                TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(top: 1),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'To pole nie może być puste';
                                      }
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text("Dodatkowe informacje"),
                          ),
                          TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
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
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text("Dodatkowe informacje"),
                          ),
                          TextFormField(
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
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
