import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:wallpaper_app/Screens/PreviewScreen/Preview.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:wallpaper_app/Scraping/scraping.dart';
import 'package:native_ads/native_ad_param.dart';
import 'package:native_ads/native_ad_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:velocity_x/velocity_x.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class Sliders extends StatefulWidget {
  Sliders({this.page, this.lists, @required this.catagory});

  int page;
  final String catagory;
  final lists;
  static const routeName = '/slider';
  final String title = "Wallpapers";

  @override
  SlidersState createState() => SlidersState();
}

class SlidersState extends State<Sliders> {
  Stream<String> progressString;
  String res;
  bool downloading = false;

  String back = '';

  @override
  Widget build(BuildContext context) {
    back = widget.lists[widget.page]['src'];
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: NetworkImage(back),
                fit: BoxFit.cover,
              ),
              color: Colors.black87,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0),
                child: Column(
                  children: <Widget>[
                    FlatButton(
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
                    SizedBox(height: 10),
                    Stack(
                      children: <Widget>[
                        CarouselSlider.builder(
                          itemCount: sliderList.length,
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.8,
                              initialPage: widget.page,
                              onPageChanged: (value, e) {
                                setState(() {
                                  widget.page = value;
                                  // favList.any((element) =>
                                  //         element == sliderList[value])
                                  //     ? alreadySaved = true
                                  //     :
                                  alreadySaved = false;
                                  value % 10 == rand ? ad = true : ad = false;
                                  adshow = false;
                                  sliderList.length - 2 == value
                                      ? loadAgain()
                                      : Text('');
                                });
                              }),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            if (itemIndex % 10 == rand || adshow == true) {
                              // ad column
                              return Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          padding: const EdgeInsets.all(5),
                                          color: Colors.grey[700],
                                          child: aad(),
                                        )),
                                  ),
                                  SizedBox(height: 10)
                                ],
                              );
                            }
                            return Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        FirebaseAnalytics().logEvent(
                                            name: 'wallpaper_preview',
                                            parameters: {
                                              'category_name': widget.catagory
                                            });
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => Preview(
                                                      src: sliderList[itemIndex]
                                                          ['extra'],
                                                    )));
                                      },
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.69,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          child: Image.network(
                                              sliderList[itemIndex]['final'],
                                              fit: BoxFit.fill, loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  child: Image.network(
                                                      sliderList[itemIndex]
                                                          ['src'],
                                                      fit: BoxFit.fill),
                                                ),
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(Colors.red),
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes
                                                        : null,
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    buttonRow(itemIndex, widget.catagory),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        loadingDialog(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ad == false
                      ? Container(
                          height: 65,
                          color: Colors.grey[700],
                          child: NativeAdView(
                            onParentViewCreated: (_) {},
                            androidParam: AndroidParam()
                              ..placementId =
                                  "ca-app-pub-4044308120454547/7953746133" // test
                              ..packageName = "com.innovidio.ez_wallpaper"
                              ..layoutName = 'native_ad1'
                              ..attributionText = "AD",
                            onAdImpression: () => print("onAdImpression!!!"),
                            onAdClicked: () => print("onAdClicked!!!"),
                            // onAdFailedToLoad: (Map<String, dynamic> error) =>
                            //     print("onAdFailedToLoad!!! $error"),
                            // onAdLoaded: () => print("Loading"),
                          ),
                        ).px2()
                      : Text("")))
        ],
      )),
    );
  }

  buttonRow(int itemIndex, String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () async {
              await Permission.storage.request();
              setState(() {
                downloading = true;
              });

              Pref().saveData();
              Pref().setData();
              GallerySaver.saveImage(sliderList[itemIndex]['extra'],
                      albumName: 'Ez Wallpaper')
                  .then((data) {
                setState(() {
                  FirebaseAnalytics().logEvent(
                      name: 'wallpaper_download',
                      parameters: {'category_name': category});
                  timer = new Timer(const Duration(milliseconds: 3000), () {
                    setState(() {
                      adshow = true;
                      downloading = false;
                    });
                    VxToast.show(context,
                        msg: data == true ? 'Save Sucessfully' : 'Not Save');
                  });
                });
              });
            },
            icon: Image.asset(
              'assets/download.png',
              color: Colors.white,
            ),
            iconSize: 46,
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () async {
              showAsBottomSheet(context,
                  category: category, url: sliderList[itemIndex]['extra']);
            },
            icon: Image.asset(
              'assets/setwallpaper.png',
              color: Colors.white,
            ),
            iconSize: 46,
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            icon: Image.asset(
              'assets/fav.png',
              color: alreadySaved == false ? Colors.white : Colors.red,
            ),
            iconSize: 46,
            onPressed: () {
              if (alreadySaved == false) {
                FirebaseAnalytics().logEvent(
                    name: 'wallpaper_add_favourite',
                    parameters: {'category_name': category});
                setState(() {
                  alreadySaved = true;
                });
              } else {
                FirebaseAnalytics().logEvent(
                    name: 'wallpaper_remove_favourite',
                    parameters: {'category_name': category});
                setState(() {
                  alreadySaved = false;
                });
              }
              add();
            },
          ),
        ),
      ],
    );
  }

  List<String> favList = [];
  bool alreadySaved = false;
  bool ad = false;

  int rand = 99;
  Timer timer;
  bool adshow = false;

  add() {
    if (alreadySaved == true) {
      favList.add(sliderList[widget.page]['final']);
      print(favList);
    } else {
      favList.remove(sliderList[widget.page]['final']);
      print(favList);
    }
  }

  adremove() {
    ad = true;
  }

  int i = 2;

  void loadAgain() {
    print('load');
    sliderscrap('https://wallpaperscraft.com/all/1080x1920/page$i')
        .then((data) {
      setState(() {
        sliderList.length;
        print(sliderList.length);
        i++;
      });
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    rand = Random().nextInt(7) + 1;
    sharepref();
    sliderList = widget.lists;
    super.initState();
  }

  sharepref() async {
    final prefs = await SharedPreferences.getInstance();
    favList = prefs.getStringList('favlist') ?? [];
    print(favList);
  }

  @override
  void dispose() {
    savepref();
    super.dispose();
  }

  savepref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favlist', favList);
    print(prefs.getStringList('favlist'));
    favList = [];
  }

  Widget aad() {
    return NativeAdView(
      onParentViewCreated: (_) {},
      androidParam: AndroidParam()
        ..placementId = "ca-app-pub-4044308120454547/7953746133" // test
        ..packageName = "com.innovidio.ez_wallpaper"
        ..layoutName = 'native_ad'
        ..attributionText = "AD",
      // iosParam: IOSParam()
      //   ..placementId = "ca-app-pub-3940256099942544/3986624511" // test
      //   ..bundleId = "{{YOUR_IOS_APP_BUNDLE_ID}}"
      //   ..layoutName = "{{YOUR_CREATED_LAYOUT_FILE_NAME}}"
      //   ..attributionText = "SPONSORED",
      onAdImpression: () => print("onAdImpression!!!"),
      onAdClicked: () => print("onAdClicked!!!"),
      // onAdFailedToLoad: (Map<String, dynamic> error) =>
      //     print("onAdFailedToLoad!!! $error"),
      // onAdLoaded: () => print("Loading"),
    );
  }

  Widget loadingDialog() {
    return Center(
      child: downloading
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 50),
              color: Colors.grey[700],
              width: 300.0,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Card(
                    color: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15),
                        SpinKitFadingCube(
                          color: Colors.white,
                          size: 20,
                        ),
                        20.heightBox,
                        'Loading...'.text.white.makeCentered()
                      ],
                    ),
                  ),
                  Divider(height: 15, color: Colors.white),
                  Container(
                    height: 300,
                    color: Colors.grey[700],
                    child: aad(),
                  )
                ],
              ),
            )
          : Text(""),
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

      VxToast.show(context, msg: result);
      FirebaseAnalytics().logEvent(
          name: 'wallpaper_set', parameters: {'category_name': category});
      setState(() {
        timer = new Timer(const Duration(milliseconds: 3000), () {
          setState(() {
            adshow = true;
            downloading = false;
          });
        });
      });
    });
  }
}

var sliderList = [];
