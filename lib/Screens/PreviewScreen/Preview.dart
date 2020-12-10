import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'dart:async';

import 'package:wallpaper_manager/wallpaper_manager.dart';

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
                    onPressed: () async {
                      setState(() {
                        downloading = true;
                      });

                      Pref().saveData();
                      Pref().setData();
                      GallerySaver.saveImage(widget.src,
                              albumName: 'Ez Wallpaper')
                          .then((data) {
                        FirebaseAnalytics().logEvent(
                            name: 'wallpaper_download',
                            parameters: {'category_name': 'Preview'});
                        setState(() {
                          downloading = false;
                        });
                        VxToast.show(context,
                            msg:
                                data == true ? 'Save Sucessfully' : 'Not Save');
                      });
                    },
                    icon: Image.asset(
                      'assets/download.png',
                      color: Colors.white,
                    ),
                    iconSize: 46,
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        downloading = true;
                      });
                      String result;
                      var file =
                          await DefaultCacheManager().getSingleFile(widget.src);
                      try {
                        result = await WallpaperManager.setWallpaperFromFile(
                            file.path, WallpaperManager.BOTH_SCREENS);
                      } on PlatformException {
                        result = 'Failed to get wallpaper.';
                      }
                      setState(() {
                        downloading = false;
                      });
                      VxToast.show(context, msg: result);
                    },
                    icon: Image.asset(
                      'assets/setwallpaper.png',
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
    return Align(
      alignment: Alignment.center,
      child: downloading == true
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFoldingCube(
                  size: 100,
                  color: Colors.white,
                ),
                20.heightBox,
                "Loading..".text.xl2.white.makeCentered()
              ],
            )
          : Text(""),
    );
  }
}
