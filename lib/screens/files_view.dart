import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:byte_converter/byte_converter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:organizerPRO/components/appbar.dart';
import 'package:organizerPRO/constants.dart';
import 'package:organizerPRO/models/file_model.dart';
import 'package:organizerPRO/services/files_service.dart';
import 'package:organizerPRO/utils/file_picker.dart';
import 'package:organizerPRO/utils/http_delete.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilesView extends StatefulWidget {
  final String objectId;

  const FilesView({Key? key, required this.objectId}) : super(key: key);

  @override
  State<FilesView> createState() => FilesViewState();
}

class FilesViewState extends State<FilesView> {
  List<PlatformFile> files = [];
  late List<FileList>? _files = [];
  String? token;
  Map item = {};
  final ReceivePort _port = ReceivePort();
  bool isLoading = false;
  String? objectId;

  @override
  void initState() {
    super.initState();
    _getData(widget.objectId);
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _getData(id) async {
    token = await storage.read(key: "token");
    _files = (await FilesService().getFileList(token, id));
    setState(() {});
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
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<String> getStorageDir() async {
    final storageDir = await getExternalStorageDirectory();
    return storageDir!.path;
  }

  void download(String fileId) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      var storageDir = await getStorageDir();
      FlutterDownloader.enqueue(
          url: "$SERVER_IP/api/fileUpload/GetFile/$fileId?naglowkowy=false",
          savedDir: storageDir,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, HeaderTitleType.fileList),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      color: Colors.transparent,
                      height: 0,
                    ),
                itemCount: _files!.length,
                itemBuilder: (BuildContext context, int index) {
                  final file = _files![index];
                  return GestureDetector(
                    onTap: () async {
                      var path =
                          "/storage/emulated/0/Download/${file.nazwaPlikuUzytkownika}";
                      if (!File(path).existsSync()) {
                        download(file.idPliku);
                      } else {
                        OpenFile.open(path);
                      }
                    },
                    child: Dismissible(
                      key: Key(file.idPliku),
                      direction: DismissDirection.endToStart,
                      behavior: HitTestBehavior.opaque,
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actionsPadding: const EdgeInsets.all(0),
                              actionsAlignment: MainAxisAlignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              title: const Text(
                                  "Czy na pewno chcesz usunąć ten plik?"),
                              content: const Text(
                                  "Po usunięciu nie możesz cofnąć tej akcji."),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: mainColor,
                                        backgroundColor: mainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Anuluj",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: deleteBtn,
                                        backgroundColor: deleteBtn,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        )),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      _showAddCarLoadingDialog(true);
                                      bool response = await deleteRecord(
                                          Endpoints.file, token, file.idPliku);
                                      if (response) {
                                        _getData(widget.objectId);
                                        _showAddCarLoadingDialog(false);
                                      }
                                    },
                                    child: const Text(
                                      "Usuń",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.white,
                        child: ListTile(
                          leading: (file.rozszerzenie == ".pdf"
                              ? Image.asset("assets/pdf_icon.png",
                                  width: 45, height: 45)
                              : file.rozszerzenie == ".txt"
                                  ? Image.asset("assets/txt_icon.png",
                                      width: 45, height: 45)
                                  : file.rozszerzenie == ".png" ||
                                          file.rozszerzenie == ".jpg" ||
                                          file.rozszerzenie == ".jpeg"
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "$SERVER_IP/api/fileUpload/GetFile/${file.idPliku}",
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/jpg_icon.png"),
                                          width: 45,
                                          height: 45,
                                          fit: BoxFit.cover)
                                      : file.rozszerzenie == ".zip" ||
                                              file.rozszerzenie == ".7z"
                                          ? Image.asset("assets/zip_icon.png",
                                              width: 45, height: 45)
                                          : Image.asset(
                                              "assets/default_icon.png",
                                              width: 45,
                                              height: 45)),
                          title: Text(
                            file.nazwaPlikuUzytkownika,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            file.wielkosc.toDouble() > 1000000
                                ? "${ByteConverter(file.wielkosc.roundToDouble()).megaBytes.toStringAsFixed(2)} MB"
                                : "${ByteConverter(file.wielkosc.roundToDouble()).kiloBytes.toStringAsFixed(2)} KB",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )),
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: secondColor,
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
            files = await filePicker(files);
            if (files.isNotEmpty) {
              setState(() {
                isLoading = true;
              });
              String? tokenVal = await storage.read(key: "token");
              var response = await FilesService()
                  .uploadFiles(tokenVal, files, widget.objectId);
              if (response.statusCode == 200) {
                setState(() {
                  _getData(widget.objectId);
                  isLoading = false;
                });
              }
            }
          }),
    );
  }
}
