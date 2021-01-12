import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePage extends StatefulWidget {
  final String imageUrl;

  ImagePage(this.imageUrl, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImagePageState();
  }
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPhoto(),
    );
  }

  Widget _buildPhoto() {
    return InkWell(
        onTap: () => Navigator.pop(context),
        child: Center(
            child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        )));
  }
}
