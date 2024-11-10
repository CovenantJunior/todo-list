import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeVideoAds extends StatefulWidget {
  /// The AdMob ad unit to show.
  ///
  /// TODO: replace this test ad unit with your own ad unit
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/1044960115'
      // ... or this one on iOS.
      : 'ca-app-pub-2287242922703560/3116579585';

  NativeVideoAds({super.key});

  @override
  State<NativeVideoAds> createState() => _NativeVideoAdsState();
}

class _NativeVideoAdsState extends State<NativeVideoAds> {
  /// The native ad to show. This is `null` until the ad is actually loaded.
  NativeAd? _nativeAd;

  bool _isAdLoaded = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isAdLoaded
        ? Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 300, // Set an appropriate height for the native video ad
            child: AdWidget(ad: _nativeAd!),
          )
        : const SizedBox(),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadNativeVideoAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  /// Loads a native video ad.
  void _loadNativeVideoAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      factoryId: 'nativeAd',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _nativeAd = ad as NativeAd;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    _nativeAd!.load();
  }
}
