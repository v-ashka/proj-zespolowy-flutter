import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class ViewPhotos extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<dynamic> imageList;

  const ViewPhotos({this.imageIndex, required this.imageList, this.heroTitle = "img"});

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;
  late int currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
      PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: pageController,
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageList[index]),
            heroAttributes:
                PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
          );
        },
        onPageChanged: onPageChanged,
        itemCount: widget.imageList.length,
        loadingBuilder: (context, progress) => Center(
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: (progress == null ||
                    progress.expectedTotalBytes == null)
                ? const CircularProgressIndicator()
                : CircularProgressIndicator(
                    value: progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!.toDouble(),
                  ),
          ),
        ),
      ),
        ],
      ),
    );
  }
}
