import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class BoxTitleBar extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const BoxTitleBar({Key? key, required this.title, required this.description, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(
                  vertical: 5),
              child: Text(
                description,
                style: const TextStyle(
                    fontSize: 12,
                    color: fontGrey,
                    fontFamily: "Roboto",
                    fontWeight:
                    FontWeight.w300),
              ),
            ),
          ],
        ),
        Icon(
          icon,
          size: 82,
          color: bg50Grey,
        ),
      ],
    );
  }
}
