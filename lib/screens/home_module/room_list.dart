import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/room_model.dart';
import 'package:organizerPRO/screens/home_module/room_form_edit.dart';
import 'package:organizerPRO/screens/home_module/room_gallery.dart';
import 'package:organizerPRO/screens/loading_screen.dart';
import 'package:organizerPRO/services/room_service.dart';

class RoomList extends StatefulWidget {
  final String homeId;
  final String homeLocation;

  const RoomList({Key? key, required this.homeId, required this.homeLocation})
      : super(key: key);

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
    setState(() {
      isGetDataFinished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGetDataFinished = false) {
      return const LoadingScreen();
    }
    return Scaffold(
        appBar:
            myAppBar(context, HeaderTitleType.rooms, "-", widget.homeLocation),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                itemCount: rooms?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(5),
                                      child: AlertDialog(
                                        actionsPadding: const EdgeInsets.all(0),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        title: const Text(
                                            "Chcesz usunąć lub edytować nazwę tego pokoju?"),
                                        content: const Text(
                                            "Wybierz jedną z opcji dostępnych poniżej."),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: mainColor,
                                                foregroundColor: mainColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                )),
                                            onPressed: () {
                                              // Navigator.pop(context);
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           CarForm(
                                              //               carId: homeItem
                                              //                   .idSamochodu,
                                              //               isEditing: true,
                                              //               brand:
                                              //               homeItem.marka,
                                              //               make: homeItem
                                              //                   .model),
                                              //     ));
                                            },
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.edit_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " Edytuj",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: deleteBtn,
                                                backgroundColor: deleteBtn,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                )),
                                            onPressed: () async {
                                              // Navigator.of(context).pop();
                                              // showDeleteDialog(true);
                                              // bool response =
                                              // await deleteRecord(
                                              //     Endpoints.carDefault,
                                              //     token,
                                              //     homeItem.idSamochodu);
                                              // if (response) {
                                              //   showDeleteDialog(false);
                                              //   getData();
                                              // }
                                            },
                                            child: RichText(
                                              text: const TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons
                                                          .delete_outline_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: " Usuń",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomGallery(
                                          roomId: room!.idPokoju!,
                                          roomName: room.nazwaPokoju!)));
                            },
                            child: CachedNetworkImage(
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "$SERVER_IP/api/fileUpload/GetFile/${room?.idPokoju}?naglowkowy=true",
                              placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text("${room?.nazwaPokoju}",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      Text("${room?.liczbaDodanychZdjec}",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54))
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
                      builder: (context) =>
                          RoomForm(homeId: widget.homeId))).then((_) {
                getRoomList();
              });
            }));
  }
}
