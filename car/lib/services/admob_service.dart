import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  final double width;
  final double height;
  final String adUnitId;

  const BannerAdWidget({
    super.key,
    required this.width,
    required this.height,
    required this.adUnitId,
  });

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState(
    width: width,
    height: height,
    adUnitId: adUnitId,
  );
}

class _BannerAdWidgetState extends State<BannerAdWidget> with WidgetsBindingObserver {
  final double width;
  final double height;
  final String adUnitId;

  BannerAd? _bannerAd;

  _BannerAdWidgetState({
    required this.width,
    required this.height,
    required this.adUnitId,
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox( // SizedBox 같은거로 영역을 제한하지 않으면 오류 발생할 수 있음
      width: width,
      height: height,
      child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : Center(child: CircularProgressIndicator()),
    );
  }

  void _loadAd() {
    setState(() {
      _bannerAd = null; // 광고 로드 시작
      print("BANNER LOAD START");
    });

    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      //size: AdSize.banner,
      size: AdSize(
        width: width.toInt(),
        height: height.toInt(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            print("BANNER LOAD SUCCESS");
            _bannerAd = ad as BannerAd; // 배너 로드 성공
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('ADMOB BANNER ERROR: $err'); // 오류 메시지 출력
          ad.dispose();
          print('Failed to load ad: $err'); // 오류 메시지 출력
          setState(() {
            _bannerAd = null; // 광고 로드 실패
          });

        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }
}