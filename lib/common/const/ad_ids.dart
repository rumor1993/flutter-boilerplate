import 'dart:io';
import 'package:flutter/foundation.dart';

class AdIds {
  // 테스트용 광고 ID
  static const String _testBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  
  // Android 실제 광고 ID
  static const String _androidBannerAdId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _androidRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  
  // iOS 실제 광고 ID
  static const String _iosBannerAdId = 'ca-app-pub-3654695184164344/3661304526';
  static const String _iosInterstitialAdId = 'ca-app-pub-3654695184164344/9731000807';
  static const String _iosRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';
  
  // 플랫폼별 광고 ID 반환 (디버그 모드에서는 테스트 광고 사용)
  static String get bannerAdId {
    if (kDebugMode) {
      return _testBannerAdId;
    }
    
    if (Platform.isAndroid) {
      return _androidBannerAdId;
    } else if (Platform.isIOS) {
      return _iosBannerAdId;
    }
    return _testBannerAdId;
  }
  
  static String get interstitialAdId {
    if (kDebugMode) {
      return _testInterstitialAdId;
    }
    
    if (Platform.isAndroid) {
      return _androidInterstitialAdId;
    } else if (Platform.isIOS) {
      return _iosInterstitialAdId;
    }
    return _testInterstitialAdId;
  }
  
  static String get rewardedAdId {
    if (kDebugMode) {
      return _testRewardedAdId;
    }
    
    if (Platform.isAndroid) {
      return _androidRewardedAdId;
    } else if (Platform.isIOS) {
      return _iosRewardedAdId;
    }
    return _testRewardedAdId;
  }
}