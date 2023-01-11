import 'package:flutter/material.dart';
import 'package:organizerPRO/constants.dart';

class ActionBoxButton extends StatefulWidget {
  final void Function()? onPressed;
  final IconData? icon;
  final String? title;
  final String? description;
  Color backgroundColor;
  ActionBoxButton(
      {Key? key,
      this.title,
      this.description,
      this.icon,
      this.onPressed,
      this.backgroundColor = mainColor})
      : super(key: key);

  @override
  State<ActionBoxButton> createState() => _ActionBoxButtonState();
}

class _ActionBoxButtonState extends State<ActionBoxButton> {
  void showDeleteDialog(isShowing) {
    if (isShowing) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              title: Text('Usuwam...'),
              content: SizedBox(
                  height: 150,
                  width: 150,
                  child: Center(
                      child: CircularProgressIndicator(color: mainColor))),
            );
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: main25Color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: widget.onPressed!,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: widget.backgroundColor,
            ),
            child: Icon(
              widget.icon,
              size: 30,
              color: bgSmokedWhite,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // "Zobacz paragon i pliki",
                  widget.title!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: fontBlack,
                      letterSpacing: 1.1),
                ),
                Text(
                  // "Wyświetl paragon w postaci zdjęcia bądź PDF.",
                  widget.description!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: fontGrey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
