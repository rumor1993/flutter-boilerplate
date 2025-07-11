import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_app/common/const/ad_ids.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _isLoadingAd = false;
  
  bool get isLoadingAd => _isLoadingAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdIds.interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          _interstitialAd!.setImmersiveMode(true);
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              // 광고가 표시될 때
            },
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              // 광고가 닫힐 때
              ad.dispose();
              _isInterstitialAdReady = false;
              // 다음 광고를 미리 로드
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              // 광고 표시 실패
              ad.dispose();
              _isInterstitialAdReady = false;
              // 다시 로드 시도
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
          // 재시도 로직 (선택사항)
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  Future<void> showInterstitialAd({
    VoidCallback? onAdClosed,
    VoidCallback? onLoadingStart,
    VoidCallback? onLoadingEnd,
  }) async {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      // 광고가 준비된 경우 바로 표시
      if (onAdClosed != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            ad.dispose();
            _isInterstitialAdReady = false;
            loadInterstitialAd();
            onAdClosed();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
            ad.dispose();
            _isInterstitialAdReady = false;
            loadInterstitialAd();
            onAdClosed();
          },
        );
      }
      
      await _interstitialAd!.show();
    } else {
      // 광고가 준비되지 않은 경우 로드 후 표시
      _isLoadingAd = true;
      onLoadingStart?.call();
      
      InterstitialAd.load(
        adUnitId: AdIds.interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) async {
            _isLoadingAd = false;
            onLoadingEnd?.call();
            
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            
            ad.setImmersiveMode(true);
            
            if (onAdClosed != null) {
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  _isInterstitialAdReady = false;
                  loadInterstitialAd();
                  onAdClosed();
                },
                onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                  ad.dispose();
                  _isInterstitialAdReady = false;
                  loadInterstitialAd();
                  onAdClosed();
                },
              );
            }
            
            await ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isLoadingAd = false;
            onLoadingEnd?.call();
            // 광고 로드 실패 시 바로 콜백 실행
            onAdClosed?.call();
          },
        ),
      );
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }
}