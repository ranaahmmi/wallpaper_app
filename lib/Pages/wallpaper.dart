import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'slider.dart';
import 'package:permission_handler/permission_handler.dart';

class Wallpaper {
  static Stream<String> imageDownloadProgress(String url) async* {
    await [
      Permission.storage,
    ].request();
    StreamController<String> streamController = new StreamController();
    try {
      final dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_PICTURES);
      print(dir);
      Dio dio = new Dio();
      dio.download(
        url,
        "$dir/myimage.jpeg",
        onReceiveProgress: (int received, int total) {
          streamController
              .add(((received / total) * 100).toStringAsFixed(0) + "%");
        },
      ).then((Response response) {
        return response;
      }).catchError((ex) {
        streamController.add(ex.toString());
      }).whenComplete(() {
        streamController.close();
      });
      yield* streamController.stream;
    } catch (ex) {
      throw ex;
    }
  }

  static Stream<String> imageDownload(String url) async* {
    await [
      Permission.storage,
    ].request();

    StreamController<String> streamController = new StreamController();
    try {
      final dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_PICTURES);
      print(dir);
      Dio dio = new Dio();
      dio
          .download(
            url,
            "$dir/Ez_Wallpaper_$j.jpeg",
            onReceiveProgress: (int received, int total) {
              streamController
                  .add(((received / total) * 100).toStringAsFixed(0) + "%");
            },
          )
          .then((Response response) {})
          .catchError((ex) {
            streamController.add(ex.toString());
          })
          .whenComplete(() {
            streamController.close();
          });
      yield* streamController.stream;
    } catch (ex) {
      throw ex;
    }
  }
}
