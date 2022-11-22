import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/components/appbar.dart';
import "package:projzespoloey/components/module_list.dart";
import 'package:chip_list/chip_list.dart';

import '../../constants.dart';

class DocumentsList extends StatefulWidget {
  const DocumentsList({Key? key}) : super(key: key);

  @override
  State<DocumentsList> createState() => _DocumentsListState();
}

final List<String> categoryList = [
  'Wszystkie',
  'Dokumenty',
  'Ubezpieczenia',
  'Umowy',
  'Faktury',
  'Inne'
];

class _DocumentsListState extends State<DocumentsList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.documentList),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: ChipList(
                listOfChipNames: categoryList,
                activeBgColorList: [secondColor],
                inactiveBgColorList: [Colors.white],
                activeTextColorList: [Colors.white],
                inactiveTextColorList: [Colors.black],
                listOfChipIndicesCurrentlySeclected: [0],
                activeBorderColorList: [secondColor],
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/form",
              arguments: {'form_type': 'add_document'});
        },
        backgroundColor: mainColor,
        label: const Text('Dodaj dokument'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
