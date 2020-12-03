import 'package:firebase_admob/firebase_admob.dart';

bool purchase = false;
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  // birthday: DateTime.now(),
  childDirected: false,
  // designedForFamilies: false,
  // gender:
  //     MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);
InterstitialAd interstitialAd = myInterstitial();
InterstitialAd myInterstitial() {
  return InterstitialAd(

    adUnitId: "ca-app-pub-3940256099942544/1033173712",

    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      if (event == MobileAdEvent.failedToLoad) {
        interstitialAd..load();
      } else if (event == MobileAdEvent.closed) {
        interstitialAd = myInterstitial()..load();
      }
    },
  );
}

BannerAd myBanner = BannerAd(
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
