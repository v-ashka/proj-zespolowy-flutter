import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:projzespoloey/constants.dart';
import 'package:projzespoloey/pages/carsModule/Car.dart';
import 'package:projzespoloey/pages/carsModule/CarApiService.dart';
import 'package:projzespoloey/services/UserModel/UserApiService.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:byte_converter/byte_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:open_file/open_file.dart';

class FilesView extends StatefulWidget {
  const FilesView({Key? key}) : super(key: key);

  @override
  State<FilesView> createState() => FilesViewState();
}

class FilesViewState extends State<FilesView> {
  List test = [1, 2, 3];
  late List<FileList>? _files = [];
  Map item = {};
  ReceivePort _port = ReceivePort();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        item = item.isNotEmpty
            ? item
            : ModalRoute.of(context)?.settings.arguments as Map;
      });
      _getData(item["data"]["idUbezpieczenia"]);
    });
     IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
      setState((){ });
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _getData(id) async {
    String? tokenVal = await storage.read(key: "token");
    print("item test");
    print(item["data"]["idUbezpieczenia"]);
    _files = (await CarApiService().GetFileList(tokenVal, id));
    Future.delayed(Duration(seconds: 0)).then((value) => setState(() {
          print("files view");
          print(_files);
        }));
  }
  @override
void dispose() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
  super.dispose();
}

@pragma('vm:entry-point')
static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}

Future<String> getStorageDir() async {
    final storageDir = await getExternalStorageDirectory();
    return storageDir!.path;
}

void download(String fileId) async {
    final status = await Permission.storage.request();
    if(status.isGranted) {
      var storageDir = await getStorageDir();
      final id = FlutterDownloader.enqueue(
          url: "$SERVER_IP/api/fileUpload/GetFile/$fileId?naglowkowy=false",
          savedDir: storageDir,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true
      );
    } else {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: secondaryColor,
              //onPrimary: Colors.transparent,
              //shadowColor: Colors.red,
              onSurface: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          foregroundColor: Colors.transparent,
          backgroundColor: secondaryColor,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              color: Colors.black),
          title: Text("Lista plików"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        color: Colors.transparent,
                      ),
                  itemCount: _files!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        //var storageDirectory = await getStorageDir();
                        var path = "/storage/emulated/0/Download/${_files![index].nazwaPlikuUzytkownika}";
                        print(path);
                        String? filePath;
                        if(!File(path).existsSync())
                          {
                            download(_files![index].idPliku);
                          }
                        else
                        {
                          OpenFile.open(path);
                        }
                    },
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.white,
                        child: ListTile(
                          leading: Icon(Icons.abc),
                          title: Text(
                            _files![index].nazwaPlikuUzytkownika,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                              _files![index].wielkosc.toDouble() < 1
                              ? "${ByteConverter(_files![index].wielkosc.roundToDouble()).megaBytes} MB"
                              : "${ByteConverter(_files![index].wielkosc.toDouble()).kiloBytes} kB",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert_outlined),
                            tooltip: "more",
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }
}
