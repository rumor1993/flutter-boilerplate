// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get base => 'BASE';

  @override
  String get appTitle => 'Photo Duplicate Finder';

  @override
  String get appSubtitle => 'Select multiple photos to compare and organize.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get gotIt => 'Got it!';

  @override
  String get showTutorial => 'Show Tutorial';

  @override
  String get resetAllTutorials => 'Reset All Tutorials';

  @override
  String get photosPreview => 'Photos Preview';

  @override
  String get selectPhotos => 'Select Photos';

  @override
  String get startComparing => 'Start Comparing';

  @override
  String get loading => 'Loading...';

  @override
  String get tutorialsResetMessage =>
      'All tutorials reset. They will show again when you navigate to each screen.';

  @override
  String get trashManagement => 'Trash Management';

  @override
  String get trashManagementDescription =>
      'Tap the trash can to permanently delete photos from your device. The red badge shows how many photos are in trash.';

  @override
  String get mainPhotoView => 'Main Photo View';

  @override
  String get mainPhotoViewDescription =>
      'Swipe left/right to compare photos. Tap to show base photo overlay for better comparison.';

  @override
  String get actionButtons => 'Action Buttons';

  @override
  String get actionButtonsDescription =>
      'Swipe to navigate photos. Use \'Set as Base\' or \'Delete\' buttons to organize the currently viewed photo.';

  @override
  String get goBackToHome => 'Go Back to Home';

  @override
  String get goBackConfirmation =>
      'Going back will clear your base photo and reset your session. Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get goBack => 'Go Back';

  @override
  String get trash => 'Trash';

  @override
  String get trashEmpty => 'Trash is empty';

  @override
  String get ok => 'OK';

  @override
  String get deleteFromDevice => 'Delete from Device';

  @override
  String get delete => 'Delete';

  @override
  String get changeBasePhoto => 'Change Base Photo';

  @override
  String get changeBasePhotoConfirmation =>
      'Do you want to set this image as the new base photo?';

  @override
  String get change => 'Change';

  @override
  String deleteConfirmation(int count) {
    return 'Do you want to permanently delete $count photo(s) from your device album?';
  }

  @override
  String get photosDeleted => 'Photos permanently deleted from device';

  @override
  String get basePhotoChanged => 'Base photo changed successfully';

  @override
  String get noPhoto => 'No Photo';

  @override
  String get photoComparison => 'Photo Comparison';

  @override
  String get basePhoto => 'Base Photo';

  @override
  String get comparisonPhoto => 'Comparison Photo';

  @override
  String get tapAnywhereToClose => 'Tap anywhere to close';

  @override
  String get photoNavigation => 'Photo Navigation';

  @override
  String get photoNavigationDescription =>
      'Swipe through photos above or tap thumbnails to navigate.\\nUse buttons below to organize the current photo.';

  @override
  String imageNumber(int number) {
    return 'Image $number';
  }

  @override
  String get isBase => 'Is Base';

  @override
  String get setAsBase => 'Set as Base';

  @override
  String get alreadyBasePhoto => 'This is already the base photo';

  @override
  String get noComparisonPhotos => 'No comparison photos available';

  @override
  String get cannotDeleteBase => 'Cannot delete base photo';

  @override
  String get noComparisonToDelete => 'No comparison photos to delete';

  @override
  String get protected => 'Protected';

  @override
  String get loadingPhotos => 'Loading photos...';

  @override
  String get findingPhotos => 'Finding photos around your base image';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get preparingPhotos => 'Preparing photos...';

  @override
  String get photosAroundBase => 'Photos around your base image';

  @override
  String selectionCounter(int selected) {
    return '$selected/30 selected';
  }

  @override
  String get noPhotosFound => 'No photos found';

  @override
  String get done => 'Done';

  @override
  String doneWithCount(int count) {
    return 'Done ($count/30)';
  }

  @override
  String doneWithSelectedCount(int count) {
    return 'Done ($count)';
  }

  @override
  String get maxPhotosSelected => 'Maximum 30 photos can be selected';

  @override
  String errorProcessingPhotos(String error) {
    return 'Error processing photos: $error';
  }

  @override
  String get switchAlbums => 'Switch Albums';

  @override
  String get switchAlbumsDescription =>
      'Tap here to switch between different photo albums on your device.';

  @override
  String get selectionCounterTitle => 'Selection Counter';

  @override
  String get selectionCounterDescription =>
      'Keep track of how many photos you\'ve selected. You can select up to 30 photos at once.';

  @override
  String get selectPhotosTitle => 'Select Photos';

  @override
  String get selectPhotosDescription =>
      'Tap photos to select them. Photos with a red border and \'BASE\' label cannot be selected as they\'re your base photo.';

  @override
  String get confirmSelection => 'Confirm Selection';

  @override
  String get confirmSelectionDescription =>
      'When you\'re done selecting photos, tap this button to add them to your comparison collection.';

  @override
  String get selectBasePhoto => 'Select Base Photo';

  @override
  String get selectBasePhotoDescription =>
      'Start by selecting a base photo that you want to compare with other photos. This will be your reference image.';

  @override
  String get addComparisonPhotos => 'Add Comparison Photos';

  @override
  String get addComparisonPhotosDescription =>
      'After selecting a base photo, use this button to add photos for comparison. You can select up to 30 photos at once!';

  @override
  String get viewAndComparePhotos => 'View and Compare Photos';

  @override
  String get viewAndComparePhotosDescription =>
      'Swipe through your photos to compare them. Your base photo will be marked with a \'BASE\' label. Swipe up on any photo to delete it.';

  @override
  String get skip => 'SKIP';

  @override
  String get addComparisonPhoto => 'Add Comparison Photo';

  @override
  String get addMultiplePhotos => 'Add Multiple Photos';

  @override
  String get selectPhotosFirstBase => 'Select Photos (First will be Base)';

  @override
  String get googleLogin => 'GOOGLE_LOGIN';

  @override
  String get logout => 'Logout';

  @override
  String get close => 'Close';
}
