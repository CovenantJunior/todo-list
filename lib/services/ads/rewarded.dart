import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAds {
  /// The AdMob ad unit to show for rewarded ads.
  final String rewardedAdUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/5224354917'
      // ... or this one on iOS.
      : 'ca-app-pub-2287242922703560/8773236536';

  /// Rewarded ad instance.
  RewardedAd? _rewardedAd;

  /// Loads a rewarded ad.
  Future<void> loadRewardedAd() async {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          // showRewardedAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          loadRewardedAd();
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  /// Displays the rewarded ad.
  bool showRewardedAd(context) {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded ad before it is loaded.');
      return false;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // Reward the user with the reward item
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        Fluttertoast.showToast(
          msg: "One-time Premium Feature Unlocked",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
      },
    );

    // Dispose of the ad after it is shown.
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        loadRewardedAd(); // Load another ad after the previous one is dismissed.
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        Fluttertoast.showToast(
          msg: "Failed to show ad",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        debugPrint('Failed to show rewarded ad: $error');
        ad.dispose();
      },
    );
    return true;
  }
}