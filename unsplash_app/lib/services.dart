import 'dart:io';
import 'dart:convert';
import 'models.dart';

class RepositoryUnsplashImages {
  final String url =
      "http://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0";

  int get length => (!_isDownloaded) ? _perPage : _images?.length;
  List<UnsplashImage> _images;
  int _indexImage = 0;
  bool _isDownloaded = false;
  bool _isDownloading = false;
  int _countPage = 0;
  int _perPage = 10;

  RepositoryUnsplashImages(int perPage) {
    _perPage = perPage;
    nextPage();
  }

  //получить следующий рисунок
  Future<UnsplashImage> get nextImage async {
    if (!_isDownloaded) {
      await nextPage();
    }
    if (_indexImage < _perPage * _countPage) {
      return _images[_indexImage++];
    } else {
      await nextPage();
      return _images[_indexImage++];
    }
  }

  //получить рисунок по индексу
  Future<UnsplashImage> getImage(int index) async {
    if (!_isDownloaded) {
      await nextPage();
    }
    if (index < _perPage * _countPage) {
      return _images[index];
    } else {
      if (_isDownloading) {
        //если что-то загружается - ждем загрузки фото с unsplash
        while (_isDownloading) {
          await Future.delayed(Duration(seconds: 1));
        }
      } else {
        await nextPage();
      }
      return _images[index];
    }
  }

  //загружает следующую страницу
  Future<void> nextPage() async {
    _isDownloading = true;
    int currPage = _countPage + 1;
    if (_images != null) {
      _images += await getImages(page: currPage, perPage: _perPage);
    } else {
      _images = await getImages(page: currPage, perPage: _perPage);
      _isDownloaded = true;
    }
    _countPage = currPage;
    _indexImage = _perPage * (_countPage - 1);
    _isDownloading = false;
  }

  //функция, которая загружает данные по страницам
  dynamic getImageData(String urlPage) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(urlPage));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String json = await response.transform(utf8.decoder).join();
      return jsonDecode(json);
    } else {
      //если что-то неправильно
      print("Http error: ${response.statusCode}");
      return [];
    }
  }

  //фунция загружает страницу рисунков с Unsplash
  Future<List> getImages({page: 1, perPage: 10}) async {
    String urlPage = url + "&page=$page" + "&per_page=$perPage";
    var data = await getImageData(urlPage);
    //создаем список данных рисунков из JSON
    List<UnsplashImage> images =
        List<UnsplashImage>.generate(data.length, (index) {
      return UnsplashImage(data[index]);
    });
    return images;
  }
}
