class UnsplashImage {
  var data;
  UnsplashImage(this.data);

  String get id => data['id'];
  String get name =>
      urlRaw.substring(urlRaw.lastIndexOf('/') + 1, urlRaw.indexOf('?'));

  String get author => getUser()['name'];

  String get urlSmall => getUrls()['small'];

  String get urlFull => getUrls()['full'];

  String get urlThumb => getUrls()['thumb'];

  String get urlRaw => getUrls()['raw'];

  String get urlRegular => getUrls()['regular'];

  String get profile128 => getProfileImages()['large'];

  getProfileImages() => data['profile_image'];

  getUrls() => data['urls'];

  getUser() => data['user'];
}
