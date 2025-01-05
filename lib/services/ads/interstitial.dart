import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAds {
  /// The AdMob ad unit to show for interstitial ads.
  /// TODO: replace this test ad unit with your own ad unit
  final String interstitialAdUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/1033173712'
      // ... or this one on iOS.
      : 'ca-app-pub-2287242922703560/8773236536';

  /// Interstitial ad instance.
  InterstitialAd? _interstitialAd;

  /// Loads an interstitial ad.
  Future<void> loadInterstitialAd(context) async {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          showInterstitialAd(context);
        },
        onAdFailedToLoad: (LoadAdError error) {
          loadInterstitialAd(context); // Retry loading the ad
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Displays the interstitial ad.
  bool showInterstitialAd(BuildContext context) {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial ad before it is loaded.');
      // loadInterstitialAd(context);
      return false;
    }

    _interstitialAd!.show();

    // Dispose of the ad after it is shown.
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // loadInterstitialAd(context); 
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        Fluttertoast.showToast(
          msg: "Failed to show ad",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        debugPrint('Failed to show interstitial ad: $error');
        ad.dispose();
      },
    );
    return true;
  }
}
