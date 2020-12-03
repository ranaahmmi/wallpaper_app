import 'package:shared_preferences/shared_preferences.dart';
import '../SliderScreen/slider.dart';
import 'ads.dart';

class Pref {
  int counter = 1;
  int ad = 1;

  saveData() async {
    final prefs = await SharedPreferences.getInstance();

    int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
  }

  loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  setData() {
    loadData().then((value) {
      print(value);
      j = value;
    });
  }

  adsaveData() async {
    final prefs = await SharedPreferences.getInstance();

    int ad = (prefs.getInt('ad') ?? 0) + 1;
    await prefs.setInt('ad', ad);
  }

  adloadData() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    return prefs.getInt('ad') ?? 0;
  }

  adsetData() {
    adloadData().then((value) {
      if (value % 3 == 0) {
        interstitialAd
          ..load()
          ..show();
      }
    });
  }
}
