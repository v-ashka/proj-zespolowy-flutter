import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projzespoloey/constants.dart';

class DashboardBox extends StatelessWidget {
   DashboardBox(
      {Key? key,
      required this.title,
      required this.description,
        this.descUpperCase,
      this.routeLink,
      required this.assetImgPath,
      this.lastAdded,
      this.additionalInfo,
      this.onPressed})
      : super(key: key);

  final String title;
  final String description;
  final String? routeLink;
  final String assetImgPath;
  final String? lastAdded;
  bool? descUpperCase=true;
  final String? additionalInfo;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, routeLink!);
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
                        descUpperCase == true ? description.toUpperCase() : description,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontFamily: "Roboto",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 3),
                      Text(lastAdded ?? additionalInfo ?? "",
                          style: const TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto')),
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
