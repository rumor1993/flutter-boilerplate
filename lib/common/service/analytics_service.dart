import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  FirebaseAnalytics get analytics => _analytics;
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // 화면 조회 이벤트
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  // 사진 관련 이벤트
  Future<void> logPhotoEvent(String eventName, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // 사진 선택 이벤트
  Future<void> logPhotoSelected({required int photoCount}) async {
    await _analytics.logEvent(
      name: 'photo_selected',
      parameters: {
        'photo_count': photoCount,
      },
    );
  }

  // 사진 비교 이벤트
  Future<void> logPhotoComparison({required String comparisonType}) async {
    await _analytics.logEvent(
      name: 'photo_comparison',
      parameters: {
        'comparison_type': comparisonType,
      },
    );
  }

  // 사진 삭제 이벤트
  Future<void> logPhotoDeleted({required int deletedCount, required bool fromTrash}) async {
    await _analytics.logEvent(
      name: 'photo_deleted',
      parameters: {
        'deleted_count': deletedCount,
        'from_trash': fromTrash,
      },
    );
  }

  // 광고 이벤트
  Future<void> logAdEvent(String eventName, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // 광고 표시 이벤트
  Future<void> logAdShown({required String adType, required String placement}) async {
    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {
        'ad_type': adType,
        'placement': placement,
      },
    );
  }

  // 광고 클릭 이벤트
  Future<void> logAdClicked({required String adType, required String placement}) async {
    await _analytics.logEvent(
      name: 'ad_clicked',
      parameters: {
        'ad_type': adType,
        'placement': placement,
      },
    );
  }

  // 튜토리얼 이벤트
  Future<void> logTutorialEvent(String eventName, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // 튜토리얼 시작
  Future<void> logTutorialBegin({required String tutorialName}) async {
    await _analytics.logEvent(
      name: 'tutorial_begin',
      parameters: {
        'tutorial_name': tutorialName,
      },
    );
  }

  // 튜토리얼 완료
  Future<void> logTutorialComplete({required String tutorialName}) async {
    await _analytics.logEvent(
      name: 'tutorial_complete',
      parameters: {
        'tutorial_name': tutorialName,
      },
    );
  }

  // 사용자 속성 설정
  Future<void> setUserProperty({required String name, required String value}) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // 사용자 ID 설정
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}