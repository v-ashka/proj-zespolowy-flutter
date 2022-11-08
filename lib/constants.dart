import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// server ip addr
//const SERVER_IP = "http://10.0.2.2:5151";

const SERVER_IP = "https://6fae-87-246-222-180.eu.ngrok.io";

// basic color app

const primaryColor = Color(0xfff8f8f8);
const primaryBgColor = Color(0xffdedede); //background color grey-white
const secondaryColor = Color(0xffefefef); // secondary color
const sliderColor = Color.fromARGB(255, 211, 211, 211); // secondary color
const buttonColor = Color(0x4000b2ff); //button color
const errorColor = Color.fromARGB(171, 255, 0, 0);
const deleteBtn = Color.fromARGB(255, 219, 58, 58);
// rgba(219, 58, 58, 1)
// Szablonowe kolorys

// kolor icon
const icon70Black = Color(0xb3000000);

// kolor tekstu
const fontGrey = Color(0xff7D7D7D);
const fontBlack = Color(0xff1E1E1E);
const fontWhite = Color.fromARGB(255, 255, 255, 255);

// kolory background
const bg100Grey = Color(0xffb2b2b2); //button color
const bg35Grey = Color(0x59b2b2b2); //bg color in list
const bg50Grey = Color.fromARGB(125, 178, 178, 178); //bg color in list
const bgSmokedWhite = Color(0xffF9F9F9);

// kolory dominujące
// niebieski do tła, niektórych ikon, buttonów, występuje w backgroundzie
const mainColor = Color(0xff00B2FF);
const main25Color = Color(0x4000b2ff);
const main50Color = Color(0x8000b2ff);

const secondColor = Color.fromARGB(255, 194, 83, 184);
const secondColorX = Color.fromARGB(89, 255, 0, 229);
const secondColor100 = Color.fromARGB(255, 154, 57, 143);
const second50Color = Color.fromARGB(25, 255, 0, 230);

final storage = new FlutterSecureStorage();
const token = "";
const payload = "";
