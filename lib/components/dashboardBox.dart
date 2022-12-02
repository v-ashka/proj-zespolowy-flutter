import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/_Dashboard.dart';
import 'package:projzespoloey/pages/carsModule/carList.dart';

class DashboardBox extends StatelessWidget {
  const DashboardBox(
      {Key? key,
      required this.title,
      required this.description,
      this.routeLink,
      required this.assetImgPath,
      this.lastAdded,
      this.additionalInfo,
      required this.user,
      this.onPressed})
      : super(key: key);

  final String title;
  final String description;
  final String? routeLink;
  final String assetImgPath;
  final String? lastAdded;
  final String? additionalInfo;
  final String? user;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    return SizedBox(
      height: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: fontBlack,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: onPressed ??
            () {
              Navigator.pushNamed(context, routeLink!, arguments: user);
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(letterSpacing: 1.2),
                      ),
                      Text(lastAdded ?? additionalInfo ?? "",
                          style: const TextStyle(
                              letterSpacing: 1.2, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Stack(
                    children: [
                      Positioned(
                        width: 150,
                        left: 0,
                        child: SvgPicture.asset(
                          assetImgPath,
                          height: 170,
                          width: 50,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
