import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';

class PasswordRequirement extends StatelessWidget {
  final bool? regExToCheck;
  final String? requirementText;
  final String? requirementTextBold;

  const PasswordRequirement({
    Key? key,
    @required this.regExToCheck,
    @required this.requirementText,
    @required this.requirementTextBold
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var passed = Colors.green[900];
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 3, 0, 3),
      child: Row(
        children: [
          regExToCheck!
              ? Icon(Icons.check_circle_rounded, color: passed)
              : const Icon(Icons.check_circle_outline_rounded, color: Colors.black87),
          const SizedBox(width: 8.0),
          Text.rich(
          TextSpan(
          style: TextStyle(
          color: regExToCheck! ? passed : Colors.black87,
            fontFamily: 'Lato',
            fontSize: 15
          ),
          children: <TextSpan>[
          TextSpan(text: requirementText),
          TextSpan(text: requirementTextBold, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
          ),
          ),
          // Text(
          //   requirementText!,
          //   style: TextStyle(
          //     color: regExToCheck! ? passed : Colors.black87,
          //     fontWeight: FontWeight.w500
          //   ),
          // )
        ],
      ),
    );
  }
}