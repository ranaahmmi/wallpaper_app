import 'dart:math';
import 'package:ext_storage/ext_storage.dart';
import 'package:wallpaper_app/Screens/PreviewScreen/Preview.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:wallpaper_app/Scraping/scraping.dart';
import 'package:native_ads/native_ad_param.dart';
import 'package:native_ads/native_ad_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/Shared/wallpaper.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'dart:ui';
import 'package:velocity_x/velocity_x.dart';

class Sliders extends StatefulWidget {
  Sliders({this.page, this.lists});

  int page;
  final lists;
  static const routeName = '/slider';
  final String title = "Wallpapers";

  @override
  SlidersState createState() => SlidersState();
}

class SlidersState extends State<Sliders> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";
  Stream<String> progressString;
  String res;
  bool downloading = false;

  // int a = 1;
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
                                  alreadySaved = false;
                                  value % 10 == rand ? ad = true : ad = false;
                                  adshow = false;
                                  sliderList.length - 2 == value
                                      ? loadAgain()
                                      : Text('');
                                });
                              }),
                          itemBuilder: (BuildContext context, int itemIndex) {
                            if (itemIndex % 10 == rand) {
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
                                          color: Colors.black45,
                                          child: aad(),
                                        )),
                                  ),
                                  SizedBox(height: 10)
                                ],
                              );
                            }
                            return adshow == false
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Preview(
                                                            src: sliderList[
                                                                    itemIndex]
                                                                ['extra'],
                                                          )));
                                            },
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.69,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                child: Image.network(
                                                    sliderList[itemIndex]
                                                        ['final'],
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Stack(
                                                    children: <Widget>[
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                        child: Image.network(
                                                            sliderList[
                                                                    itemIndex]
                                                                ['src'],
                                                            fit: BoxFit.fill),
                                                      ),
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              new AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.red),
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
                                          buttonRow(itemIndex),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
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
                                              color: Colors.black45,
                                              child: aad(),
                                            )),
                                      ),
                                      SizedBox(height: 10)
                                    ],
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
                          color: Colors.black45,
                          child: NativeAdView(
                            onParentViewCreated: (_) {},
                            androidParam: AndroidParam()
                              ..placementId =
                                  "ca-app-pub-4044308120454547/5083320694" // test
                              ..packageName = "com.innovidio.ez_wallpaper"
                              ..layoutName = 'native_ad1'
                              ..attributionText = "AD",
                            onAdImpression: () => print("onAdImpression!!!"),
                            onAdClicked: () => print("onAdClicked!!!"),
                            onAdFailedToLoad: (Map<String, dynamic> error) =>
                                print("onAdFailedToLoad!!! $error"),
                            onAdLoaded: () => print("Loading"),
                          ),
                        ).px2()
                      : Text("")))
        ],
      )),
    );
  }

  buttonRow(int itemIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () {
              Pref().saveData();
              Pref().setData();
              progressString =
                  Wallpaper.imageDownload(sliderList[itemIndex]['extra']);
              progressString.listen((data) {
                setState(() {
                  res = data;
                  downloading = true;
                });
              }, onDone: () {
                timer = new Timer(const Duration(milliseconds: 3000), () {
                  setState(() {
                    adshow = true;
                    downloading = false;
                    home = home;
                  });
                  print("Task Done");
                });
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
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () {
              progressString = Wallpaper.imageDownloadProgress(
                  sliderList[itemIndex]['extra']);
              progressString.listen((data) {
                setState(() {
                  res = data;
                  downloading = true;
                });
              }, onDone: () async {
                print('done');
                final dir = await ExtStorage.getExternalStoragePublicDirectory(
                    ExtStorage.DIRECTORY_PICTURES);

                Wallpaperplugin.setAutoWallpaper(
                    localFile: '$dir/myimage.jpeg');
                timer = new Timer(const Duration(milliseconds: 1000), () {
                  setState(() {
                    adshow = true;
                    downloading = false;
                    home = home;
                  });
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
                setState(() {
                  alreadySaved = true;
                });
              } else {
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
  var rng = new Random();
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
    rand = rng.nextInt(8);
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
        ..placementId = "ca-app-pub-4044308120454547/5083320694" // test
        ..packageName = "com.innovidio.ez_wallpaper"
        ..layoutName = 'native_ad'
        ..attributionText = "AD",
      iosParam: IOSParam()
        ..placementId = "ca-app-pub-3940256099942544/3986624511" // test
        ..bundleId = "{{YOUR_IOS_APP_BUNDLE_ID}}"
        ..layoutName = "{{YOUR_CREATED_LAYOUT_FILE_NAME}}"
        ..attributionText = "SPONSORED",
      onAdImpression: () => print("onAdImpression!!!"),
      onAdClicked: () => print("onAdClicked!!!"),
      onAdFailedToLoad: (Map<String, dynamic> error) =>
          print("onAdFailedToLoad!!! $error"),
      onAdLoaded: () => print("Loading"),
    );
  }

  Widget loadingDialog() {
    return Center(
      child: downloading
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 50),
              color: Colors.black45,
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
                        CircularProgressIndicator(),
                        SizedBox(height: 20.0),
                        Text(
                          "Downloading File : $res",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Divider(height: 15, color: Colors.white),
                  Container(
                    height: 300,
                    // child: aad(),
                  )
                ],
              ),
            )
          : Text(""),
    );
  }
}

int j = 1;
var sliderList = [];
