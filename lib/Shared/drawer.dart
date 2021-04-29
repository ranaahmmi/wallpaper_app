import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:wallpaper_app/Screens/%20favorite/Save.dart';
import 'package:wallpaper_app/Screens/About/About.dart';
import 'package:wallpaper_app/Screens/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/Screens/PrivacyPolicy/Privacy_policy.dart';
import 'package:wallpaper_app/Shared/ads.dart';

class DrawerList extends StatefulWidget {
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return drawerlist();
  }

  drawerlist() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
          Colors.black54,
          Colors.blueGrey,
        ])),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/logo1.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Wallpapers Daily 2021',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    )
                  ],
                ),
              ),
            ),
            OpenList(Icons.crop_original, 'Wallpaper', () {
              interstitialAd..show();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            }),
            Divider(
              color: Colors.grey,
            ),
            OpenList(Icons.favorite, 'Saved', () {
              FirebaseAnalytics().logEvent(name: 'saved_wallpaper_open');
              interstitialAd..show();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Save()));
            }),
            Divider(
              color: Colors.grey,
            ),
            OpenList(Icons.rate_review, 'Rate Us', () {
//              StoreRedirect.redirect();
            }),
            OpenList(Icons.info, 'About', () {
              interstitialAd..show();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => About()));
            }),
            OpenList(Icons.poll, 'Privacy Policy', () {
              interstitialAd..show();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            }),
          ],
        ),
      ),
    );
  }
}

class OpenList extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  OpenList(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: InkWell(
        splashColor: Colors.black,
        onTap: onTap,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 19.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
