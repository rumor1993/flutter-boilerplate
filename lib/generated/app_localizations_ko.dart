// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get base => '기준';

  @override
  String get appTitle => '사진 중복 찾기';

  @override
  String get appSubtitle => '여러 사진을 선택하여 비교하고 정리하세요.';

  @override
  String get getStarted => '시작하기';

  @override
  String get next => '다음';

  @override
  String get gotIt => '알겠습니다!';

  @override
  String get showTutorial => '튜토리얼 보기';

  @override
  String get resetAllTutorials => '모든 튜토리얼 초기화';

  @override
  String get photosPreview => '사진 미리보기';

  @override
  String get selectPhotos => '사진 선택';

  @override
  String get startComparing => '비교 시작';

  @override
  String get loading => '로딩 중...';

  @override
  String get tutorialsResetMessage =>
      '모든 튜토리얼이 초기화되었습니다. 각 화면으로 이동할 때 다시 표시됩니다.';

  @override
  String get trashManagement => '휴지통 관리';

  @override
  String get trashManagementDescription =>
      '휴지통을 탭하여 기기에서 사진을 영구적으로 삭제하세요. 빨간색 배지는 휴지통에 있는 사진 수를 표시합니다.';

  @override
  String get mainPhotoView => '메인 사진 보기';

  @override
  String get mainPhotoViewDescription =>
      '좌우로 스와이프하여 사진을 비교하세요. 탭하면 더 나은 비교를 위해 기준 사진 오버레이가 표시됩니다.';

  @override
  String get actionButtons => '액션 버튼';

  @override
  String get actionButtonsDescription =>
      '스와이프하여 사진을 탐색하세요. \'기준으로 설정\' 또는 \'삭제\' 버튼을 사용하여 현재 보고 있는 사진을 정리하세요.';

  @override
  String get goBackToHome => '홈으로 돌아가기';

  @override
  String get goBackConfirmation => '돌아가면 기준 사진이 지워지고 세션이 초기화됩니다. 계속하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get goBack => '돌아가기';

  @override
  String get trash => '휴지통';

  @override
  String get trashEmpty => '휴지통이 비어있습니다';

  @override
  String get ok => '확인';

  @override
  String get deleteFromDevice => '기기에서 삭제';

  @override
  String get delete => '삭제';

  @override
  String get changeBasePhoto => '기준 사진 변경';

  @override
  String get changeBasePhotoConfirmation => '이 이미지를 새로운 기준 사진으로 설정하시겠습니까?';

  @override
  String get change => '변경';

  @override
  String deleteConfirmation(int count) {
    return '기기 앨범에서 $count개의 사진을 영구적으로 삭제하시겠습니까?';
  }

  @override
  String get photosDeleted => '사진이 기기에서 영구적으로 삭제되었습니다';

  @override
  String get basePhotoChanged => '기준 사진이 성공적으로 변경되었습니다';

  @override
  String get noPhoto => '사진 없음';

  @override
  String get photoComparison => '사진 비교';

  @override
  String get basePhoto => '기준 사진';

  @override
  String get comparisonPhoto => '비교 사진';

  @override
  String get tapAnywhereToClose => '아무 곳이나 탭하여 닫기';

  @override
  String get photoNavigation => '사진 탐색';

  @override
  String get photoNavigationDescription =>
      '위의 사진을 스와이프하거나 썸네일을 탭하여 탐색하세요.\\n아래 버튼을 사용하여 현재 사진을 정리하세요.';

  @override
  String imageNumber(int number) {
    return '이미지 $number';
  }

  @override
  String get isBase => '기준임';

  @override
  String get setAsBase => '기준으로 설정';

  @override
  String get alreadyBasePhoto => '이미 기준 사진입니다';

  @override
  String get noComparisonPhotos => '비교 사진이 없습니다';

  @override
  String get cannotDeleteBase => '기준 사진은 삭제할 수 없습니다';

  @override
  String get noComparisonToDelete => '삭제할 비교 사진이 없습니다';

  @override
  String get protected => '보호됨';

  @override
  String get loadingPhotos => '사진 로딩 중...';

  @override
  String get findingPhotos => '기준 이미지 주변의 사진을 찾는 중';

  @override
  String get loadingMore => '더 로딩 중...';

  @override
  String get preparingPhotos => '사진 준비 중...';

  @override
  String get photosAroundBase => '기준 이미지 주변의 사진';

  @override
  String selectionCounter(int selected) {
    return '$selected/30개 선택됨';
  }

  @override
  String get noPhotosFound => '사진을 찾을 수 없습니다';

  @override
  String get done => '완료';

  @override
  String doneWithCount(int count) {
    return '완료 ($count/30)';
  }

  @override
  String doneWithSelectedCount(int count) {
    return '완료 ($count)';
  }

  @override
  String get maxPhotosSelected => '최대 30개의 사진을 선택할 수 있습니다';

  @override
  String errorProcessingPhotos(String error) {
    return '사진 처리 오류: $error';
  }

  @override
  String get switchAlbums => '앨범 전환';

  @override
  String get switchAlbumsDescription => '여기를 탭하여 기기의 다른 사진 앨범으로 전환하세요.';

  @override
  String get selectionCounterTitle => '선택 카운터';

  @override
  String get selectionCounterDescription =>
      '선택한 사진의 수를 추적하세요. 한 번에 최대 30개의 사진을 선택할 수 있습니다.';

  @override
  String get selectPhotosTitle => '사진 선택';

  @override
  String get selectPhotosDescription =>
      '사진을 탭하여 선택하세요. 빨간색 테두리와 \'기준\' 라벨이 있는 사진은 기준 사진이므로 선택할 수 없습니다.';

  @override
  String get confirmSelection => '선택 확인';

  @override
  String get confirmSelectionDescription =>
      '사진 선택이 완료되면 이 버튼을 탭하여 비교 컬렉션에 추가하세요.';

  @override
  String get selectBasePhoto => '기준 사진 선택';

  @override
  String get selectBasePhotoDescription =>
      '먼저 다른 사진과 비교할 기준 사진을 선택하세요. 이것이 참조 이미지가 됩니다.';

  @override
  String get addComparisonPhotos => '비교 사진 추가';

  @override
  String get addComparisonPhotosDescription =>
      '기준 사진을 선택한 후 이 버튼을 사용하여 비교할 사진을 추가하세요. 한 번에 최대 30개의 사진을 선택할 수 있습니다!';

  @override
  String get viewAndComparePhotos => '사진 보기 및 비교';

  @override
  String get viewAndComparePhotosDescription =>
      '사진을 스와이프하여 비교하세요. 기준 사진에는 \'기준\' 라벨이 표시됩니다. 사진을 위로 스와이프하여 삭제하세요.';

  @override
  String get skip => '건너뛰기';

  @override
  String get addComparisonPhoto => '비교 사진 추가';

  @override
  String get addMultiplePhotos => '여러 사진 추가';

  @override
  String get selectPhotosFirstBase => '사진 선택 (첫 번째가 기준)';

  @override
  String get googleLogin => '구글 로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get close => '닫기';
}
