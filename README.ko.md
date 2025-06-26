# Flutter Boilerplate

인증, 상태 관리, 라우팅, API 통합이 포함된 프로덕션 준비 완료 Flutter 보일러플레이트입니다.

## 🚀 주요 기능

- **🔐 완전한 인증 시스템** - Google Sign-In, JWT 토큰 관리, 보안 저장소
- **⚡ 현대적인 상태 관리** - Riverpod + 코드 생성
- **🧭 선언적 라우팅** - GoRouter 기반 타입 안전 라우팅
- **📡 API 통합** - Dio HTTP 클라이언트, 자동 토큰 갱신
- **🎨 Material Design 3** - 현대적이고 반응형 UI
- **🔧 개발자 도구** - 린팅, 코드 생성, 로깅, 환경 설정

## 📋 요구사항

- Flutter SDK 3.7.0 이상
- Dart 3.0.0 이상

## 🛠️ 빠른 시작

### 1. 자동 설정 (권장)

```bash
# 저장소 클론
git clone <repository-url>
cd flutter_boilerplate

# 설정 스크립트 실행
./setup.sh
```

### 2. 수동 설정

```bash
# 의존성 설치
flutter pub get

# 코드 생성
dart run build_runner build

# 환경 설정 파일 생성
cp .env.example .env

# 애플리케이션 실행
flutter run --dart-define-from-file=.env
```

## ⚙️ 환경 설정

### 1. 환경 변수 설정

`.env` 파일을 편집하여 설정을 구성하세요:

```env
# API 설정
API_BASE_URL=https://your-api.com
API_TIMEOUT=30000

# Google Sign-In 설정
GOOGLE_CLIENT_ID_IOS=your_ios_client_id
GOOGLE_CLIENT_ID_ANDROID=your_android_client_id
GOOGLE_CLIENT_ID_WEB=your_web_client_id

# 개발 환경
DEBUG_MODE=true
LOG_LEVEL=debug
```

### 2. Google Sign-In 설정

#### Android
1. [Google Cloud Console](https://console.cloud.google.com/)에서 프로젝트 생성
2. `google-services.json` 파일을 `android/app/` 디렉토리에 추가
3. `android/app/build.gradle`에 Google Services 플러그인 추가

#### iOS
1. [Google Cloud Console](https://console.cloud.google.com/)에서 iOS 클라이언트 생성
2. `GoogleService-Info.plist` 파일을 `ios/Runner/` 디렉토리에 추가
3. `ios/Runner/Info.plist`에 URL scheme 추가

## 📁 프로젝트 구조

```
lib/
├── common/                 # 공통 유틸리티 및 컴포넌트
│   ├── component/         # 재사용 가능한 UI 컴포넌트
│   ├── config/           # 앱 설정
│   ├── const/            # 상수 (색상, 데이터 키)
│   ├── dio/              # HTTP 클라이언트 설정
│   ├── layout/           # 레이아웃 위젯
│   ├── provider/         # 전역 프로바이더 (라우팅)
│   ├── secoure_storage/  # 보안 저장소 유틸리티
│   ├── utils/            # 유틸리티 함수
│   └── view/             # 공통 화면
├── home/                  # 홈 기능
│   └── view/             # 홈 화면
├── user/                  # 인증 기능
│   ├── model/            # 사용자 데이터 모델
│   ├── provider/         # 사용자 관련 프로바이더
│   ├── repository/       # API 저장소
│   └── view/             # 인증 화면
└── main.dart             # 앱 진입점
```

## 🏗️ 아키텍처

### 상태 관리
- **Riverpod**: 반응형 상태 관리
- **코드 생성**: 프로바이더와 모델 자동 생성
- **AsyncValue**: 로딩 상태 및 에러 처리

### 인증 플로우
- **Google Sign-In**: 소셜 로그인 통합
- **JWT 토큰 관리**: 자동 토큰 갱신
- **보안 저장소**: 안전한 토큰 저장
- **라우트 보호**: 인증 상태 기반 라우팅

### API 통합
- **Dio**: HTTP 클라이언트 with 인터셉터
- **자동 토큰 주입**: 인증된 요청을 위한 자동 토큰 추가
- **토큰 갱신**: 자동 토큰 갱신 처리
- **로깅**: 디버그 모드에서 요청/응답 로깅

### 라우팅
- **GoRouter**: 선언적, 타입 안전 라우팅
- **라우트 가드**: 인증 기반 라우트 보호
- **딥 링킹**: 딥 링크 지원
- **네비게이션 상태**: 네비게이션 상태 관리

## 🔧 개발 도구

### 코드 생성
```bash
# 모든 생성 코드 빌드
dart run build_runner build

# 변경사항 감시하며 자동 생성
dart run build_runner watch

# 충돌 파일 삭제 후 생성
dart run build_runner build --delete-conflicting-outputs
```

### 린팅 및 분석
```bash
# 코드 분석
flutter analyze

# 코드 포맷팅
dart format .

# 린트 규칙 확인
flutter pub run custom_lint
```

### 테스트
```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/widget_test.dart

# 커버리지 포함 테스트
flutter test --coverage
```

## 📱 빌드 및 배포

### 개발 빌드
```bash
flutter run --dart-define-from-file=.env
```

### 프로덕션 빌드
```bash
# Android APK
flutter build apk --dart-define-from-file=.env.prod

# Android App Bundle
flutter build appbundle --dart-define-from-file=.env.prod

# iOS
flutter build ios --dart-define-from-file=.env.prod
```

## 🔒 보안 고려사항

- **민감한 정보**: `.env` 파일은 버전 관리에 포함하지 마세요
- **토큰 저장**: Flutter Secure Storage를 사용한 안전한 토큰 저장
- **API 키**: 프로덕션 환경에서는 적절한 API 키 관리
- **난독화**: 프로덕션 빌드 시 코드 난독화 고려

## 📝 사용 예시

### 새로운 기능 추가

1. **새로운 기능 디렉토리 생성**
```
lib/
└── my_feature/
    ├── model/
    ├── provider/
    ├── repository/
    └── view/
```

2. **모델 정의**
```dart
@freezed
class MyModel with _$MyModel {
  factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;
  
  factory MyModel.fromJson(Map<String, dynamic> json) => 
      _$MyModelFromJson(json);
}
```

3. **프로바이더 생성**
```dart
@riverpod
class MyProvider extends _$MyProvider {
  @override
  Future<MyModel> build() async {
    // 비즈니스 로직
  }
}
```

### API 호출 예시

```dart
@riverpod
class MyRepository extends _$MyRepository {
  @override
  Dio build() => ref.watch(dioProvider);
  
  Future<MyModel> getData() async {
    final response = await build().get('/my-endpoint');
    return MyModel.fromJson(response.data);
  }
}
```

## 🤝 기여하기

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🐛 버그 리포트 및 기능 요청

[Issues](https://github.com/your-username/flutter_boilerplate/issues)에서 버그를 신고하거나 새로운 기능을 요청하세요.

## 📚 추가 리소스

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Riverpod 문서](https://riverpod.dev/)
- [GoRouter 문서](https://pub.dev/packages/go_router)
- [Dio 문서](https://pub.dev/packages/dio)

---

**즐거운 Flutter 개발 되세요! 🎉**