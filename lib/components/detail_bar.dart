import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class DetailBar extends StatelessWidget {
  final String title;
  final String value;
  const DetailBar({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$title:   ",
            style: const TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: secondaryColor),
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
