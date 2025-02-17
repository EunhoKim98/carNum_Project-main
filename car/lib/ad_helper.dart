import 'dart:async';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  bool _initialized = false;

  void loadBanner(Function(BannerAd) onLoaded) async {
    await _initialize();

    final banner = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd),
      ),
    );

    banner.load();
  }

  void loadInterstitial(Function(InterstitialAd) onLoaded) async {
    await _initialize();

    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => onLoaded(ad) ,
        onAdFailedToLoad: (e) {
          print('[!] ADMOB ERROR! ' + e.toString());
        },
      ),
    );
  }

  Future<void> _initialize() async {
    if (!_initialized) {
      await MobileAds.instance.initialize();
      print('ADMOB INITIALIZE SUCCESS');
      _initialized = true;
    }
  }

  String _getBannerAdUnitId() {
    if (Platform.isAndroid) {
      print('is Android, Banner');
      return 'ca-app-pub-6715466232441720/3974272160';
    }
    if (Platform.isIOS) {
      print('is iOS, Banner');
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw StateError("Unsupported platform");
  }

  String _getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      print('is Android, _getInterstitialAdUnitId');

      return 'ca-app-pub-6715466232441720/4675035777';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw StateError('Unsupported platform');
  }
}
