import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:string_validator/string_validator.dart' as Validate;

class Header extends StatefulWidget {
  const Header({Key? key, required this.data, required this.size})
      : super(key: key);

  final Map data;
  final Size size;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    void _onSettingsPressed() {
      bool isSwitched =  Validate.toBoolean(widget.data['userData']['settings']['receiptVisible']);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(children: <Widget>[
                SwitchListTile(
                  title: Text("Moduł pojazdy"),
                  subtitle: Text("$isSwitched"),
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                      print(value);
                    }
                    );
                  },
                )
              ]);
            });
          });
    };

    print("${widget.data}");
    return Container(
      height: widget.size.height * 0.3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            //height: 126,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                            text: 'Organizer',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.black,
                                fontFamily: 'Lato'),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'PRO',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: mainColor))
                            ]),
                      ),
                      Spacer(),
                      Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                              onPressed: () => _onSettingsPressed(),
                              icon: Icon(Icons.notifications, size: 25))),
                      Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                              onPressed: () => _onSettingsPressed(),
                              icon: Icon(Icons.settings, size: 25))),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
                      child: Text(
                        'Witaj ${widget.data['userData']['name']}!',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              fontSize: 40,
                            ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 20, 0),
                    child: Text(
                      'Zarządzaj swoim ekranem głównym dodając lub usuwając moduły',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
