import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projzespoloey/components/add_attachment_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/document_model.dart';
import 'package:projzespoloey/models/home_repair_model.dart';
import 'package:projzespoloey/pages/homeModule/home_repair_list.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/services/home_service.dart';
import 'package:projzespoloey/utils/date_picker.dart';

class HomeRepairForm extends StatefulWidget {
  final bool isEditing;
  final HomeRepairModel? repair;
  final String homeId;

  const HomeRepairForm(
      {Key? key, this.isEditing = false, this.repair, required this.homeId})
      : super(key: key);

  @override
  State<HomeRepairForm> createState() => _HomeRepairFormState();
}

class _HomeRepairFormState extends State<HomeRepairForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  final _formKey = GlobalKey<FormState>();
  String? token;
  HomeRepairModel repair = HomeRepairModel();
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    if (widget.isEditing) {
      repair = widget.repair!;
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
              title: Text('Zapisuję naprawę...'),
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
        appBar: myAppBar(
            context,
            widget.isEditing
                ? (HeaderTitleType.formEditHomeRepair)
                : (HeaderTitleType.formAddHomeRepair)),
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
                                        "Wprowadź szczegóły naprawy",
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
                                        "Nazwa naprawy",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'To pole nie może być puste!';
                                        }
                                        return null;
                                      },
                                      initialValue: repair.nazwaNaprawy,
                                      onSaved: (String? value) {
                                        repair.nazwaNaprawy = value;
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.label_outline,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Wykonawca naprawy",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: repair.wykonawcaNaprawy,
                                      onSaved: (String? value) {
                                        repair.wykonawcaNaprawy = value;
                                      },
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.handyman_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Wykonawca",
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Koszt naprawy",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: repair.kosztNaprawy,
                                      onSaved: (String? value) {
                                        repair.kosztNaprawy = value;
                                      },
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp("[-, ]"))
                                      ],
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(15),
                                          prefixIcon: const Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(
                                              Icons.attach_money_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Koszt naprawy",
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Data naprawy",
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
                                          repair.dataNaprawy =
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
                                          hintText: repair.dataNaprawy ??
                                              "Data naprawy",
                                          hintStyle: TextStyle(
                                              color: repair.dataNaprawy != null
                                                  ? Colors.black
                                                  : Colors.black54),
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
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Opis naprawy",
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
                                        initialValue: repair.opis,
                                        maxLines: 4,
                                        onSaved: (String? value) {
                                          repair.opis = value;
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
                                                "Dodaj opis przeprowadzonej naprawy...",
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
                                AddAttachmentButton(
                                    formType: FormType.repair,
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
                        repair.dataNaprawy ??=
                            DateTime.now().toString().substring(0, 10);
                      });
                      showAddDocumentLoadingDialog(true);
                      if (!widget.isEditing) {
                        Response? response = await HomeService()
                            .addHomeRepair(widget.homeId, repair, token);
                        if (files.isNotEmpty && response!.statusCode == 200 ||
                            response!.statusCode == 202) {
                          await FilesService()
                              .uploadFiles(token, files, response.data);
                        }
                      } else {
                        // await DocumentService().updateDocument(
                        //     token, document, document.idDokumentu);
                      }
                      setState(() {
                        showAddDocumentLoadingDialog(false);
                      });
                    }
                  },
                  backgroundColor: mainColor,
                  label: Text(widget.isEditing
                      ? ("Zapisz naprawę")
                      : ("Dodaj naprawę")),
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
