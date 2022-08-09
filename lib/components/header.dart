import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class Header extends StatefulWidget {
  const Header({Key? key, required this.data, required this.size}) : super(key: key);

  final Map data;
  final Size size;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    // print("${widget.data}");
    return Container(
      height: widget.size.height * 0.1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            height: widget.size.height *0.1,
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Text(
                    'Witaj ${widget.data['userData']['name']} ${widget.data['userData']['surname']}!',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 2.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );  }
}
