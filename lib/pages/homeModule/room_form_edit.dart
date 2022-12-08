import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projzespoloey/components/add_photo_button.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/room_model.dart';
import 'package:projzespoloey/pages/documentsModule/documentsList.dart';
import 'package:projzespoloey/pages/homeModule/homeItem.dart';
import 'package:projzespoloey/pages/homeModule/homeList.dart';
import 'package:projzespoloey/services/document_service.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/services/room_service.dart';

class RoomForm extends StatefulWidget {
  final bool isEditing;
  final RoomModel? room;
  final String homeId;

  const RoomForm({Key? key, this.isEditing = false, this.room, required this.homeId})
      : super(key: key);

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  bool isValid = false;
  bool isLoading = true;
  bool isLoadingBtn = false;
  final _formKey = GlobalKey<FormState>();
  String? token;
  List documentCategories = [];
  RoomModel room = RoomModel();
  List<PlatformFile> files = [];
  File? image;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    token = await storage.read(key: "token");
    documentCategories = (await DocumentService().getCategories(token));
    if (widget.isEditing) {
      room = widget.room!;
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
              title: Text('Zapisuję pokój...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(
          context,
          widget.isEditing
              ? (HeaderTitleType.formEditRoom)
              : (HeaderTitleType.formAddRoom)),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
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
                                        "Wprowadź nazwę pokoju",
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
                                        "Nazwa pokoju",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      initialValue: room.nazwaPokoju ?? "",
                                      onSaved: (String? value) {
                                        room.nazwaPokoju = value;
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
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Proszę podać nazwę pomieszczenia';
                                          }else if (image == null){
                                            return 'Zdjęcia pomieszczenia nie może być puste!';
                                          }
                                          return null;
                                        }
                                    ),
                                    AddPhotoButton(onChanged: (roomImage) {
                                      image = roomImage;
                                    })
                                  ],
                                ),
                              ]),
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
                    Response? response =
                        await RoomService().addRoom(widget.homeId, room.nazwaPokoju!, token!);
                    if (image != null && response?.statusCode == 200) {
                      await FilesService().uploadFile(
                          token, image!.path.toString(), response?.data);
                    } else {}
                  }
                  setState(() {
                    showAddDocumentLoadingDialog(false);
                  });
                },
                backgroundColor: secondColor,
                label: Text(widget.isEditing
                    ? ("Zapisz pokój")
                    : ("Dodaj pokój")),
                icon: const Icon(Icons.check),
              ),
            ),
    );
  }
}
