import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.6),
              Container(
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.white)),
                      child:
                          'Apply now'.text.white.make().pSymmetric(h: 20, v: 5)
                      //  Image.asset(
                      //   'assets/setwallpaper.png',
                      //   height: 46,
                      //   color: Colors.white,
                      // ),
                      )
                  .onTap(() async {
                showAsBottomSheet(context,
                    category: 'Priview', url: widget.src);
              }),
            ],
          ),
          dialog()
        ],
      ),
    );
  }

  showAsBottomSheet(context, {String url, String category}) async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        color: Colors.black,
        backdropColor: Colors.black.withOpacity(0.4),
        elevation: 8,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          snappings: [0.9, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return Container(
            height: 150,
            child: Material(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Wrap(
                    spacing: 10.0, // gap between adjacent chips
                    runSpacing: 10.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,

                    children: [
                      setWallpaperButton(
                              url: url,
                              category: category,
                              text: 'Home Screen',
                              icon: Icons.home,
                              location: 'HomeScreen')
                          .w(150),
                      setWallpaperButton(
                              url: url,
                              category: category,
                              text: 'Lock Screen',
                              icon: Icons.phonelink_lock_sharp,
                              location: 'LockScreen')
                          .w(150),
                      setWallpaperButton(
                              url: url,
                              category: category,
                              text: 'Both Screen',
                              icon: Icons.all_inbox_rounded,
                              location: 'Both')
                          .w(150)
                    ],
                  ),
                )),
          );
        },
      );
    });
  }

  Widget setWallpaperButton(
      {@required String url,
      @required String category,
      @required String text,
      @required IconData icon,
      @required String location}) {
    return VxBox(
            child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        text.text.white.make()
      ],
    ))
        .padding(EdgeInsets.symmetric(horizontal: 10))
        .border(color: Colors.grey, style: BorderStyle.solid)
        .roundedLg
        .height(40)
        .make()
        .onTap(() async {
      Navigator.pop(context);
      setState(() {
        downloading = true;
      });
      String result;
      var file = await DefaultCacheManager().getSingleFile(url);

      try {
        result = location == 'HomeScreen'
            ? await WallpaperManager.setWallpaperFromFile(
                file.path, WallpaperManager.HOME_SCREEN)
            : location == 'LockScreen'
                ? await WallpaperManager.setWallpaperFromFile(
                    file.path, WallpaperManager.LOCK_SCREEN)
                : await WallpaperManager.setWallpaperFromFile(
                    file.path, WallpaperManager.BOTH_SCREENS);
      } on PlatformException {
        result = 'Failed to get wallpaper.';
      }
      setState(() {
        downloading = false;
      });

      VxToast.show(context, msg: result);
      FirebaseAnalytics().logEvent(
          name: 'wallpaper_set', parameters: {'category_name': category});
    });
  }

  Widget dialog() {
    return Align(
      alignment: Alignment.center,
      child: downloading == true
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitFadingCircle(
                  size: 40,
                  color: Colors.white,
                ),
                10.heightBox,
                "Loading...".text.bold.xl.italic.white.makeCentered().shimmer()
              ],
            )
          : Text(""),
    );
  }
}
