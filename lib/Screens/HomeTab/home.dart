import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:wallpaper_app/Screens/SliderScreen/slider.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:wallpaper_app/Scraping/scraping.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  int i = 2;
  @override
  void initState() {
    FirebaseAnalytics().logEvent(name: 'home_tab_open');
    loaddata();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadAgain();
      }
    });
    super.initState();
  }

  void loadAgain() {
    FirebaseAnalytics().logEvent(
        name: 'wallpaper_load_more',
        parameters: {'category_name': 'Popular', 'page_count': i});
    sdscrap('https://wallpaperscraft.com/all/1080x1920/page$i').then((data) {
      setState(() {
        i++;
      });
    });
  }

  void loaddata() {
    sdscrap('https://wallpaperscraft.com/all/1080x1920').then((data) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Popular',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: wallpaper())
            ],
          ),
        ),
      ],
    );
  }

  wallpaper() {
    return wallpaperlist.length > 0
        ? GridView.builder(
            controller: scrollController,
            itemCount: wallpaperlist.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.2),
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == wallpaperlist.length) {
                return CupertinoActivityIndicator();
              }
              final wallpaper = wallpaperlist[index];
              return GestureDetector(
                onTap: () {
                  Pref().adsetData();
                  Pref().adsaveData();
                  FirebaseAnalytics().logEvent(
                      name: 'wallpaper_open',
                      parameters: {'category_name': 'Popular'});
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Sliders(
                              page: index,
                              lists: wallpaperlist,
                              catagory: 'Popular',
                            )),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Image.network(
                      wallpaper['src'],
                      fit: BoxFit.fitWidth,
                    )),
              );
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

var wallpaperlist = [];
