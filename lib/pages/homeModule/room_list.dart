import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/file_model.dart';
import 'package:projzespoloey/models/room_model.dart';
import 'package:projzespoloey/pages/homeModule/room_form_edit.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/services/room_service.dart';

class RoomList extends StatefulWidget {
  final String homeId;
  final String homeLocation;
  const RoomList({Key? key, required this.homeId, required this.homeLocation}) : super(key: key);

  @override
  State<RoomList> createState() => RoomListState();
}

class RoomListState extends State<RoomList> {
  List<RoomModel>? rooms = [];
  String? token;
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    getRoomList();
  }

  void getRoomList() async {
    token = await storage.read(key: "token");
    rooms = await RoomService().getRoomList(widget.homeId, token);
    setState(() {isGetDataFinished = true;});
  }

  void _showAddCarLoadingDialog(isShowing) {
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
    if(isGetDataFinished = false){
      return const LoadingScreen();
    }
    return Scaffold(
        appBar: myAppBar(context, HeaderTitleType.rooms, "-", widget.homeLocation),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: GridView.builder(
                padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                itemCount: rooms?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 30.0),
                itemBuilder: (BuildContext context, int index) {
                  var room = rooms?[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () async {},
                            child: CachedNetworkImage(
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              imageUrl: "$SERVER_IP/api/fileUpload/GetFile/${room?.idPokoju}?naglowkowy=true",
                              placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("${room?.nazwaPokoju}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600))
                    ],
                  );
                })),
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () {
        //       // Navigator.push(
        //       //     context,
        //       //     MaterialPageRoute(
        //       //         builder: (context) => const HomeForm()));
        //     },
        //     backgroundColor: mainColor,
        //     label: const Text('Dodaj pomieszczenie'),
        //     icon: const Icon(Icons.add)
            floatingActionButton: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondColor,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15)),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: bgSmokedWhite,
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoomForm(homeId: widget.homeId))).then((_) {
                    getRoomList();
                  });;
                      }));
  }
}
