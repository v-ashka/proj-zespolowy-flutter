import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DocumentItem extends StatefulWidget {
  const DocumentItem({Key? key}) : super(key: key);

  @override
  State<DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item"),
      ),
    );
  }
}
