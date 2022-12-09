// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:projzespoloey/components/photo_view.dart';
// import 'package:projzespoloey/constants.dart';
// import 'package:projzespoloey/utils/http_delete.dart';
//
// class GalleryGrid extends StatefulWidget {
//   final List<String> imageList;
//
//   const GalleryGrid({Key? key, required this.imageList}) : super(key: key);
//
//   @override
//   State<GalleryGrid> createState() => GalleryGridState();
// }
//
// class GalleryGridState extends State<GalleryGrid> {
//   @override
//   Widget build(BuildContext context) {
//     void _showAddCarLoadingDialog(isShowing) {
//       if (isShowing) {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return const AlertDialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(25.0))),
//                 title: Text('Usuwam...'),
//                 content: SizedBox(
//                     height: 150,
//                     width: 150,
//                     child: Center(
//                         child: CircularProgressIndicator(color: mainColor))),
//               );
//             });
//       } else {
//         Navigator.of(context, rootNavigator: true).pop();
//       }
//     }
//
//     String? token = "";
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       body: Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/background.png'), fit: BoxFit.fill)),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: GridView.builder(
//               itemCount: imageList.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 6.0,
//                   mainAxisSpacing: 6.0),
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onLongPress: () {
//                     SystemSound.play(SystemSoundType.alert);
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return Container(
//                             padding: const EdgeInsets.all(5),
//                             child: AlertDialog(
//                               actionsPadding: const EdgeInsets.all(0),
//                               actionsAlignment: MainAxisAlignment.center,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               title: const Text("Chcesz usunąć to zdjęcie?"),
//                               actions: [
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: mainColor,
//                                       foregroundColor: mainColor,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(25),
//                                       )),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: RichText(
//                                     text: const TextSpan(
//                                       children: [
//                                         WidgetSpan(
//                                           child: Icon(
//                                             Icons.close,
//                                             size: 20,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                             text: " Zamknij",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontFamily: 'Lato',
//                                                 fontWeight: FontWeight.w600)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: deleteBtn,
//                                       onPrimary: deleteBtn,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(25),
//                                       )),
//                                   onPressed: () async {
//                                     Navigator.of(context).pop();
//                                     _showAddCarLoadingDialog(true);
//                                     token = await storage.read(key: "token");
//                                     bool response = await deleteRecord(
//                                         Endpoints.file, token, file.idPliku);
//                                     if (response) {
//                                       _getData(widget.objectId);
//                                       _showAddCarLoadingDialog(false);
//                                     }
//                                   },
//                                   child: RichText(
//                                     text: const TextSpan(
//                                       children: [
//                                         WidgetSpan(
//                                           child: Icon(
//                                             Icons.delete_outline_outlined,
//                                             size: 20,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                             text: " Usuń",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontFamily: 'Lato',
//                                                 fontWeight: FontWeight.w600)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         });
//                   },
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) {
//                               return ViewPhotos(
//                                 imageIndex: index,
//                                 imageList: imageList,
//                                 heroTitle: "image$index",
//                               );
//                             },
//                             fullscreenDialog: true));
//                   },
//                   child: Container(
//                     child: Hero(
//                         tag: "photo$index",
//                         child: CachedNetworkImage(
//                           fit: BoxFit.cover,
//                           imageUrl: imageList[index],
//                           placeholder: (context, url) =>
//                               const Center(child: CupertinoActivityIndicator()),
//                           errorWidget: (context, url, error) =>
//                               Icon(Icons.error),
//                         )),
//                   ),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }
