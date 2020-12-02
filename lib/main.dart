import 'package:wallpaper_app/HomeScreen.dart';
import 'package:wallpaper_app/Pages/Sub_catagories.dart';
import 'package:wallpaper_app/Pages/slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EZ WallPaper',
        theme: ThemeData(
          primaryColor: Colors.blueGrey[900],
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          Sliders.routeName: (ctx) => Sliders(),
          SubCategories.routeName: (ctx) => SubCategories(),
        });
  }
}
