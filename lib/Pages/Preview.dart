import 'package:ext_storage/ext_storage.dart';
import 'package:wallpaper_app/Pages/Shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'dart:ui';
import 'wallpaper.dart';
import 'dart:async';

class Preview extends StatefulWidget {
  Preview({this.src});
  final String src;
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";
  Stream<String> progressString;
  String res;
  bool downloading = false;

  int a = 1;
  String back = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87,
            child: Image.network(widget.src, fit: BoxFit.cover, loadingBuilder:
                (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.arrow_back_ios,
                            size: 30, color: Colors.white),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Pref().saveData();
                      Pref().setData();
                      progressString = Wallpaper.imageDownload(widget.src);

                      progressString.listen((data) {
                        setState(() {
                          res = data;
                          downloading = true;
                        });
                      }, onDone: () {
                        setState(() {
                          downloading = false;
                          home = home;
                        });
                        print("Task Done");
                      }, onError: (error) {
                        setState(() {
                          downloading = false;
                        });
                        print("Some Error");
                      });
                    },
                    icon: Image.asset(
                      'assets/w_down.png',
                      color: Colors.white,
                    ),
                    iconSize: 46,
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      progressString =
                          Wallpaper.imageDownloadProgress(widget.src);

                      progressString.listen((data) {
                        setState(() {
                          res = data;
                          downloading = true;
                        });
                      }, onDone: () async {
                        print('done');
                        final dir =
                            await ExtStorage.getExternalStoragePublicDirectory(
                                ExtStorage.DIRECTORY_PICTURES);

                        Wallpaperplugin.setAutoWallpaper(
                            localFile: '$dir/myimage.jpeg');
                        setState(() {
                          downloading = false;
                          home = home;
                        });
                        print("Task Done");
                      }, onError: (error) {
                        setState(() {
                          downloading = false;
                        });
                        print("Some Error");
                      });
                    },
                    icon: Image.asset(
                      'assets/w_icon.png',
                      color: Colors.white,
                    ),
                    iconSize: 46,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          dialog()
        ],
      ),
    );
  }

  Widget dialog() {
    return Positioned(
      top: 200,
      left: 95,
      child: downloading
          ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      "Downloading File : $res",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          : Text(""),
    );
  }
}
