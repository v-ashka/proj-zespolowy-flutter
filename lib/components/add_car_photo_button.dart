// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/utils/photo_picker.dart';



class AddCarPhotoButton extends StatefulWidget {
  File? image;
  AddCarPhotoButton({Key? key, required this.image}) : super(key: key);

  @override
  State<AddCarPhotoButton> createState() => _AddCarPhotoButtonState();
}

class _AddCarPhotoButtonState extends State<AddCarPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text("Zdjęcie pojazdu"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: widget.image != null
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () async{
                  widget.image = await pickImage();
                  setState(() {
                  widget.image;
                  });
                  
                },
                child: widget.image != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: secondaryColor,
                          image: DecorationImage(
                            image: FileImage(widget.image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: 100,
                        height: 100,
                      )
                    : const Icon(Icons.add_a_photo_outlined,
                        size: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

