import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/utils/http_delete.dart';

enum AlertDialogType {
  carDefault,
  carInsurance,
  carInspection,
  carRepair,
  car,
  document
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
      case AlertDialogType.car:
        return 'ten pojazd';
      case AlertDialogType.document:
        return 'ten dokument';
    }
  }
}

class DeleteButton extends StatefulWidget {
  final Endpoints endpoint;
  final String? token;
  final String? id;
  final AlertDialogType dialogtype;
  final Function() callback;
  Function()? callbackSec;
  DeleteButton(
      {Key? key,
      required this.endpoint,
      required this.token,
      required this.id,
      required this.dialogtype,
      required this.callback,
      this.callbackSec})
      : super(key: key);

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  void showDeleteDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: SizedBox(
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
          foregroundColor: deleteBtn,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(5),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          )),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(5),
                child: AlertDialog(
                  actionsPadding: const EdgeInsets.all(0),
                  actionsAlignment: MainAxisAlignment.center,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  title: Text(
                      "Czy na pewno chcesz usunąć ${widget.dialogtype.text}?"),
                  content:
                      const Text("Po usunięciu nie możesz cofnąć tej akcji."),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: mainColor,
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Anuluj",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: deleteBtn,
                            backgroundColor: deleteBtn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showDeleteDialog(true);

                          bool response = await deleteRecord(
                              widget.endpoint, widget.token, widget.id);

                          if (response) {
                            widget.callback.call();
                            widget.callbackSec?.call();
                            showDeleteDialog(false);
                          }
                        },
                        child: const Text(
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
        child: const Icon(
          Icons.delete_outline_rounded,
          size: 30,
          color: bgSmokedWhite,
        ),
      ),
    );
  }
}
