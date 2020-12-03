import 'package:flutter/material.dart';
import 'package:wallpaper_app/Screens/CategoriesTab/categories.dart';
import 'package:wallpaper_app/Screens/HomeTab/home.dart';
import 'package:wallpaper_app/Screens/SearchScreen/Search.dart';
import 'package:wallpaper_app/Shared/drawer.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:wallpaper_app/Shared/ads.dart';
import 'package:native_ads/native_ads.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    interstitialAd = myInterstitial()..load();
    NativeAds.initialize();
    super.initState();
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerList(),
      appBar: AppBar(
        title: !isSearching
            ? Text('EZ Wallpaper')
            : TextField(
                autofocus: true,
                onSubmitted: (value) {
                  print(value);
                  var b = [
                    {
                      'name': value,
                      'url':
                          'https://wallpaperscraft.com/search/?order=&page=1&query=$value&size=1080x1920'
                    },
                  ];
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Search(
                            url: b[0]['url'],
                            name: b[0]['name'],
                          )));
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Categories Or Colors",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        elevation: 0.7,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "HOME",
            ),
            Tab(text: 'CATEGORIES'),
          ],
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
//                      filterCountries = countries;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          HomeScreen(),
          Categories(),
        ],
      ),
    );
  }
}
