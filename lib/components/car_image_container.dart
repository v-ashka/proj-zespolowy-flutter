import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

// item["data"]["car_info"]["image"]
class CarImageContainer extends StatelessWidget {
  final String image;
  final String brand;
  final String model;
  final int prodYear;
  final String carRegNumber;

  const CarImageContainer(
      {Key? key,
      required this.image,
      required this.brand,
      required this.model,
      required this.prodYear,
      required this.carRegNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "$SERVER_IP/api/fileUpload/GetFile/$image?naglowkowy=true"),
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
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: secondaryColor),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
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
                                brand,
                                style: const TextStyle(
                                  color: fontWhite,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            const SizedBox(
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
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                            model,
                            style: const TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(
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
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Text("ROCZNIK",
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
                            "$prodYear",
                            style: const TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(
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
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Text("NR REJESTRACYJNY",
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
                            carRegNumber,
                            style: const TextStyle(
                              color: fontWhite,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
