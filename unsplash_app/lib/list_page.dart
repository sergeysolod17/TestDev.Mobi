import 'package:flutter/material.dart';
import 'package:unsplash_app/image_tile.dart';
import 'package:unsplash_app/models.dart';
import 'services.dart';
import 'dart:ui';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  RepositoryUnsplashImages images = RepositoryUnsplashImages(
      (window.physicalSize.height / _sizeProfileImg).round() + 5);
  static const double _sizeProfileImg = 128;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return ListView.builder(itemBuilder: (context, index) {
            return FutureBuilder(
                future: _getImage(index),
                builder: (context, AsyncSnapshot<UnsplashImage> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    //children = <Widget>[Text('TEST')];
                    children = <Widget>[ImageTile(snapshot.data)];
                  } else {
                    children = <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: _sizeProfileImg,
                        height: _sizeProfileImg,
                      )
                    ];
                  }
                  return Row(
                    children: children,
                  );
                });
          });
        },
      ),
    );
  }

  Future<UnsplashImage> _getImage(index) async {
    return await images.getImage(index);
  }
}
