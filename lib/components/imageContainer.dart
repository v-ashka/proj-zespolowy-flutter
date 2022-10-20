import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/constants.dart';

// item["data"]["car_info"]["image"]
class CarImageContainer extends StatelessWidget {
  const CarImageContainer(
      {required this.image,
      required this.brand,
      required this.model,
      required this.prodDate,
      required this.engine,
      required this.vinNr,
      required this.carRegNumber});
  final String image;
  final String brand;
  final String model;
  final int prodDate;
  final int engine;
  final String vinNr;
  final String carRegNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("${SERVER_IP}/api/fileUpload/GetFile/$image?naglowkowy=true"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(25),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: secondaryColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Text("MARKA",
                                  style: TextStyle(
                                    color: fontBlack,
                                    fontSize: 6,
                                  )),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: mainColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 2),
                              child: Text(
                                "${brand}",
                                style: TextStyle(
                                  color: fontWhite,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: secondaryColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Text("NR REJ.",
                                  style: TextStyle(
                                    color: fontBlack,
                                    fontSize: 6,
                                  )),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: mainColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 2),
                              child: Text(
                                "${carRegNumber}",
                                style: TextStyle(
                                  color: fontWhite,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: secondaryColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Text("MODEL",
                              style: TextStyle(
                                color: fontBlack,
                                fontSize: 6,
                              )),
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                            "${model}",
                            style: TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: secondaryColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Text("`DATA PROD`.",
                              style: TextStyle(
                                color: fontBlack,
                                fontSize: 6,
                              )),
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                            "${prodDate}",
                            style: TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: secondaryColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Text("SILNIK",
                              style: TextStyle(
                                color: fontBlack,
                                fontSize: 6,
                              )),
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                            "${engine}",
                            style: TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: secondaryColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Text("VIN",
                              style: TextStyle(
                                color: fontBlack,
                                fontSize: 6,
                              )),
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: Text(
                            "${vinNr}",
                            style: TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
