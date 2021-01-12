import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'image_page.dart';
import 'models.dart';

class ImageTile extends StatelessWidget {
  final UnsplashImage image;

  ImageTile(this.image, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<Null>(
              builder: (BuildContext context) => ImagePage(image.urlRegular)),
        );
      },
      child: image != null
          ? Hero(
              tag: '${image.id}',
              child: Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: image?.urlThumb,
                      width: window.physicalSize.width * 0.17,
                      height: window.physicalSize.width * 0.17,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        height: window.physicalSize.width * 0.15,
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: window.physicalSize.width * 0.27,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        'Название: ${image.name}',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Автор: ${image.author}')
                                  ],
                                )
                              ],
                            )))
                  ])),
            )
          : Container(
              color: Colors.grey[100],
            ),
    );
  }
}
