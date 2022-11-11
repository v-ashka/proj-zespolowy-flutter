import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/utils/http_delete.dart';

enum AlertDialogType {
  carDefault,
  carInsurance,
  carInspection,
  carRepair,
}

extension FormTypeExtension on AlertDialogType {
  String get text {
    switch (this) {
      case AlertDialogType.carDefault:
        return 'ten pojazd';
      case AlertDialogType.carInsurance:
        return 'tą polisę';
      case AlertDialogType.carInspection:
        return 'ten przegląd';
      case AlertDialogType.carRepair:
        return 'tą naprawę';
    }
  }
}

class DeleteButton extends StatefulWidget {
  final Endpoints endpoint;
  final String? token;
  final String? id;
  final AlertDialogType dialogtype;
  Future<dynamic>? refreshData;
  final VoidCallback callback;
  DeleteButton(
      {Key? key,
      required this.endpoint,
      required this.token,
      required this.id,
      required this.dialogtype,
      this.refreshData,
      required this.callback})
      : super(key: key);

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  void _showAddCarLoadingDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: Container(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(5),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          onPrimary: deleteBtn,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          )),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(5),
                child: AlertDialog(
                  actionsPadding: EdgeInsets.all(0),
                  actionsAlignment: MainAxisAlignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: Text(
                      "Czy na pewno chcesz usunąć ${widget.dialogtype.text}?"),
                  content: Text("Po usunięciu nie możesz cofnąć tej akcji."),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: mainColor,
                            onPrimary: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Anuluj",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: deleteBtn,
                            onPrimary: deleteBtn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                        onPressed: () async {
                          print("delete test");
                          Navigator.of(context).pop();
                          _showAddCarLoadingDialog(true);
                          var response = await deleteRecord(
                              widget.endpoint.text, widget.token, widget.id);
                          if (response as bool) {
                            setState(() {
                              print("test del;ete");

                              widget.callback;
                              _showAddCarLoadingDialog(false);
                            });
                          }
                        },
                        child: Text(
                          "Usuń",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              );
            });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: deleteBtn,
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          size: 30,
          color: bgSmokedWhite,
        ),
      ),
    );
  }
}
