import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_app/models.dart';
import 'services.dart';
import 'dart:ui';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RepositoryUnsplashImages images;
  final int sizeProfileImg = 128;

  @override
  void initState() {
    super.initState();

    images = RepositoryUnsplashImages(
        ((window.physicalSize.width / sizeProfileImg) *
                (window.physicalSize.height / sizeProfileImg))
            .round());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return CustomScrollView(
            slivers: <Widget>[_buildImageGrid()],
          );
        },
      ),
    );
  }

  Widget _buildImageGrid({orientation = Orientation.portrait}) {
    int columnCount = ((orientation == Orientation.portrait)
            ? (MediaQuery.of(context).size.width / sizeProfileImg)
            : (MediaQuery.of(context).size.height / sizeProfileImg))
        .round();

    return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverStaggeredGrid.countBuilder(
          crossAxisCount: columnCount,
          staggeredTileBuilder: (index) => _buildStaggeredTile(columnCount),
          itemBuilder: (context, index) => _buildImageItem(index),
          itemCount: images.length,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ));
  }

  StaggeredTile _buildStaggeredTile(int columnCount) {
    return StaggeredTile.fit(1);
  }

  Widget _buildImageItem(int index) {
    return FutureBuilder<UnsplashImage>(
        future: images.nextImage,
        builder: (context, AsyncSnapshot<UnsplashImage> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[Image.network(snapshot.data.profile128)];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(Icons.error_outline, color: Colors.red, size: 15)
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 25,
                height: 25,
              )
            ];
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ));
        });
  }
}
