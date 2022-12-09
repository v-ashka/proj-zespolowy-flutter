import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projzespoloey/components/appbar.dart';
import 'package:projzespoloey/utils/photo_picker.dart';
import 'package:projzespoloey/components/gallery_grid.dart';
import 'package:projzespoloey/components/photo_view.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/models/file_model.dart';
import 'package:projzespoloey/pages/loadingScreen.dart';
import 'package:projzespoloey/services/files_service.dart';
import 'package:projzespoloey/utils/http_delete.dart';

class RoomGallery extends StatefulWidget {
  final String roomId;
  final String roomName;

  const RoomGallery({Key? key, required this.roomId, required this.roomName})
      : super(key: key);

  @override
  State<RoomGallery> createState() => RoomGalleryState();
}

class RoomGalleryState extends State<RoomGallery> {
  List<FileList>? fileList = [];
  List<String> urlList = [];
  List<PlatformFile> files = [];
  String? token;
  bool isLoading = false;
  bool isGetDataFinished = false;

  @override
  void initState() {
    super.initState();
    getFilesList();
  }

  void getFilesList() async {
    token = await storage.read(key: "token");
    fileList = await FilesService().getFileList(token, widget.roomId);
    if (fileList != null) {
      urlList = fileList!
          .map((e) => "$SERVER_IP/api/fileUpload/GetFile/${e.idPliku}")
          .toList();
    }
    setState(() {
      isGetDataFinished = true;
    });
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
    if (isGetDataFinished = false) {
      return const LoadingScreen();
    }
    return Scaffold(
        appBar: myAppBar(context, HeaderTitleType.photo, "-", widget.roomName),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  itemCount: fileList?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0),
                  itemBuilder: (BuildContext context, int index) {
                    var image = fileList![index];
                    return InkWell(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                child: AlertDialog(
                                  actionsPadding:
                                  const EdgeInsets.all(0),
                                  actionsAlignment:
                                  MainAxisAlignment.center,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25),
                                  ),
                                  title: const Text(
                                      "Chcesz usunąć to zdjęcie?"),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: mainColor,
                                          foregroundColor: mainColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25),
                                          )),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.close,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                                text: " Zamknij",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Lato',
                                                    fontWeight:
                                                    FontWeight
                                                        .w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: deleteBtn,
                                          onPrimary: deleteBtn,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25),
                                          )),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        _showAddCarLoadingDialog(true);
                                        token = await storage.read(key: "token");
                                        bool response = await deleteRecord(
                                            Endpoints.file, token, image.idPliku);
                                        if (response) {
                                          getFilesList();
                                          _showAddCarLoadingDialog(false);
                                        }
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
                                                    FontWeight
                                                        .w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) {
                                  return ViewPhotos(
                                    imageIndex: index,
                                    imageList: urlList,
                                    heroTitle: "image$index",
                                  );
                                },
                                fullscreenDialog: true));
                      },
                      child: Container(
                        child: Hero(
                            tag: "photo$index",
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: "$SERVER_IP/api/fileUpload/GetFile/${image.idPliku}",
                              placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )),
                      ),
                    );
                  }),
            )),
        floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: secondColor,
                foregroundColor: secondColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15)),
            child: isLoading
                ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
                : const Icon(
              Icons.add,
              size: 30,
              color: bgSmokedWhite,
            ),
            onPressed: () async {
              files = await pickImages(files);
              if (files.isNotEmpty) {
                setState(() {
                  isLoading = true;
                });
                String? tokenVal = await storage.read(key: "token");
                var response = await FilesService()
                    .uploadFiles(tokenVal, files, widget.roomId);
                if (response.statusCode == 200) {
                  setState(() {
                    getFilesList();
                    isLoading = false;
                  });
                }
              }
            }));
  }
}
