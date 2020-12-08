import 'package:flutter/services.dart';
import 'package:wallpaper_app/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:wallpaper_app/Screens/SubCategoriesScreen/Sub_catagories.dart';


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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
        title: 'EZ WallPaper',
        theme: ThemeData(
          primaryColor: Colors.blueGrey[900],
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          SubCategories.routeName: (ctx) => SubCategories(),
        });
  }
}
