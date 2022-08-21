import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projzespoloey/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final moduleItems = ['Dokumenty', 'Paraogny', 'Samochody', 'Sprzęt domowy'];
    final modulesTexts = {
      "module": [
        {"title": "Dokumenty", "subtitle": "Ostatnio dodany dokument", "img": "assets/my_files.svg", "subtitleCount": "Ilość dokumentów"},
        {"title": "Paragony", "subtitle": "Ostatnio dodany paragon", "img": "assets/receipt.svg", "subtitleCount": "Ilość paragonów"},
        {"title": "Samochód", "subtitle_car": "Następny przegląd za", "img": "assets/cars.svg", "subtitleCount": "Zapisane pojazdy"},
        {"title": "Sprzęt domowy", "subtitle": "Ostatnio dodany przedmiot", "img": "assets/house.svg", "subtitleCount": "Ilość przedmiotów"},
      ]
    };

    final colors = [main25Color, main50Color];
    print(modulesTexts["module"]!.length);
     return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.fill)
          ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,25,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                        text: const TextSpan(
                            text: 'Organizer',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'PRO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: mainColor))
                            ]),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                        Stack(
                          children: [
                            Positioned(
                              top: 7,
                              left: 25,
                              child: Container(
                                width: 13,
                                height: 13,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  "0",
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                              ),
                            ),
                          IconButton(
                              onPressed: null,
                            icon: Icon(Icons.notifications, size: 25),
                          ),
                          ],
                        ),
                        IconButton(
                              onPressed: null,
                            icon: Icon(Icons.settings, size: 25),
                        ),
                      ],
                    ),
                    SizedBox(height: 25,),
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                        text: const TextSpan(
                            text: 'Witaj,',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w300
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' userDefault',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: mainColor))
                            ]),
                      ),
                      SizedBox(height: 10,),
                      Text("Zarządzaj swoim ekranem głównym, ustawiając moduły do wyświetlenia", style: TextStyle(fontSize: 18),),
                      SizedBox(height: 40),
                      ],
                    ),
                    // Modules column
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,15),
                      child: Text(
                        "Kategorie",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                        child: ListView.separated(
                          itemCount: modulesTexts["module"]!.length,
                          itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: width,
                            height: height/5,
                            decoration: BoxDecoration(
                              color: bgSmokedWhite,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15,20,0,0),
                                    child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [  
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          "${modulesTexts["module"]![index]["title"]}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ), 
                                      modulesTexts["module"]![index]["subtitle"] == null ? (
                                        Text(
                                          "${modulesTexts["module"]![index]["subtitle_car"]}",
                                          style: TextStyle(letterSpacing: 1.2),
                                          )
                                        ):(
                                          Text(
                                            "${modulesTexts["module"]![index]["subtitle"]}",
                                             style: TextStyle(letterSpacing: 1.2),
                                             )
                                        ),
                                        // product name OR car datetime
                                        modulesTexts["module"]![index]["subtitle"] == null ? (
                                        Text(
                                          "20 dni",
                                          style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w900),
                                          )
                                        ):(
                                          Text(
                                            "Umowa o pracę",
                                             style: TextStyle(letterSpacing: 1.2,  fontWeight: FontWeight.w900),
                                             )
                                        ),
                                    ]
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                        child: ClipRRect(
                                          child: Container(
                                            width: 130,
                                          height: height,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          )
                                        ),
                                      ),
                                      Positioned(      
                                        width: 150,
                                        left: 10,
                                        child: Container(
                                          height: 165,
                                          width: 130,
                                          alignment: Alignment(2,2),
                                          child: SvgPicture.asset(
                                            "${modulesTexts["module"]![index]["img"]}",
                                             height: 170,
                                             width: 50,
                                               allowDrawingOutsideViewBox: true,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
                        ),
                    )
                  ]
                ),
            ),
        ),
      ),
     );
  }
}