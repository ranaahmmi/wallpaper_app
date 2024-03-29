import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:wallpaper_app/Screens/HomeTab/home.dart';
import 'package:wallpaper_app/Screens/SliderScreen/slider.dart';
import 'package:wallpaper_app/Screens/SubCategoriesScreen/Sub_catagories.dart';

sdscrap(String url) async {
  Uri uri = Uri.parse(url);
  var client = Client();
  Response response = await client.get(uri);
  if (response.statusCode == 200) {
    var document = parse(response.body);
    List<dom.Element> links = document
        .querySelectorAll('span.wallpapers__canvas > img.wallpapers__image');
    for (var link in links) {
      wallpaperlist.add({
        'src': link.attributes['src'],
        'final':
            link.attributes['src'].replaceAll('168x300.jpg', '720x1280.jpg'),
        'extra':
            link.attributes['src'].replaceAll('168x300.jpg', '1080x1920.jpg')
      });
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

cscrap(String url) async {
  var client = Client();
  Uri uri = Uri.parse(url);

  Response response = await client.get(uri);
  if (response.statusCode == 200) {
    var document = parse(response.body);
    List<dom.Element> links = document
        .querySelectorAll('span.wallpapers__canvas > img.wallpapers__image');
    for (var link in links) {
      categorieslist.add({
        'src': link.attributes['src'],
        'final':
            link.attributes['src'].replaceAll('168x300.jpg', '1080x1920.jpg'),
        'extra':
            link.attributes['src'].replaceAll('168x300.jpg', '1080x1920.jpg')
      });
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

sliderscrap(String url) async {
  var client = Client();
  Uri uri = Uri.parse(url);
  Response response = await client.get(uri);
  if (response.statusCode == 200) {
    var document = parse(response.body);
    List<dom.Element> links = document
        .querySelectorAll('span.wallpapers__canvas > img.wallpapers__image');
    for (var link in links) {
      sliderList.add({
        'src': link.attributes['src'],
        'final':
            link.attributes['src'].replaceAll('168x300.jpg', '720x1280.jpg'),
        'extra':
            link.attributes['src'].replaceAll('168x300.jpg', '1080x1920.jpg')
      });
      print(sliderList.length);
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
