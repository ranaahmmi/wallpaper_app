import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
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
                    10.heightBox,
                    Row(
                      children: <Widget>[
                        Icon(Icons.arrow_back_ios,
                            size: 30, color: Colors.white),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ).px(20).onTap(() {
                      Navigator.pop(context);
                    }),
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
                                  // alreadySaved = false;
                                  value % 10 == rand ? ad = true : ad = false;
                                  adshow = false;
                                  sliderList.length - 2 == value
                                      ? loadAgain()
                                      : Text('');
                                });
                              }),
                          itemBuilder:
                              (BuildContext context, int itemIndex, a) {
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
                                    SizedBox(height: 10),
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
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(99)),
                child: Image.asset(
                  'assets/download.png',
                  height: 40,
                ).p(5))
            .onTap(() async {
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
        }),
        SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(99)),
          child: Center(
              child: LikeButton(
            animationDuration: Duration(milliseconds: 700),
            bubblesSize: 120,
            size: 40,
            circleColor:
                CircleColor(start: Color(0xFFFF3C00), end: Color(0xFF5E220A)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xFFFF3C00),
              dotSecondaryColor: Color(0xFFC74512),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
                size: 40,
              );
            },
            onTap: (isLiked) async {
              if (!isLiked) {
                FirebaseAnalytics().logEvent(
                    name: 'wallpaper_add_favourite',
                    parameters: {'category_name': category});
                favList.add(sliderList[widget.page]['final']);
                print(favList);
              } else {
                favList.remove(sliderList[widget.page]['final']);
                print(favList);
              }
              return !isLiked;
            },
          ).p(5)),
        ),
      ],
    );
  }

  List<String> favList = [];
  // bool alreadySaved = false;
  bool ad = false;

  int rand = 99;
  Timer timer;
  bool adshow = false;

  // add() {
  //   if (alreadySaved == true) {
  //     favList.add(sliderList[widget.page]['final']);
  //     print(favList);
  //   } else {
  //     favList.remove(sliderList[widget.page]['final']);
  //     print(favList);
  //   }
  // }

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
                        10.heightBox,
                        SpinKitFadingCircle(
                          size: 40,
                          color: Colors.white,
                        ),
                        10.heightBox,
                        "Loading..."
                            .text
                            .bold
                            .xl
                            .italic
                            .white
                            .makeCentered()
                            .shimmer()
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
}

var sliderList = [];
