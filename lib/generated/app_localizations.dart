import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// Label for base photo in photo comparison
  ///
  /// In en, this message translates to:
  /// **'BASE'**
  String get base;

  /// Main application title
  ///
  /// In en, this message translates to:
  /// **'Photo Duplicate Finder'**
  String get appTitle;

  /// App subtitle description
  ///
  /// In en, this message translates to:
  /// **'Select multiple photos to compare and organize.'**
  String get appSubtitle;

  /// Tutorial header
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Final tutorial button
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get gotIt;

  /// Menu option to show tutorial
  ///
  /// In en, this message translates to:
  /// **'Show Tutorial'**
  String get showTutorial;

  /// Menu option to reset tutorials
  ///
  /// In en, this message translates to:
  /// **'Reset All Tutorials'**
  String get resetAllTutorials;

  /// Photos preview placeholder text
  ///
  /// In en, this message translates to:
  /// **'Photos Preview'**
  String get photosPreview;

  /// Button text when no photos selected
  ///
  /// In en, this message translates to:
  /// **'Select Photos'**
  String get selectPhotos;

  /// Button text when photos are selected
  ///
  /// In en, this message translates to:
  /// **'Start Comparing'**
  String get startComparing;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'All tutorials reset. They will show again when you navigate to each screen.'**
  String get tutorialsResetMessage;

  /// Tutorial title for trash management
  ///
  /// In en, this message translates to:
  /// **'Trash Management'**
  String get trashManagement;

  /// Tutorial description for trash management
  ///
  /// In en, this message translates to:
  /// **'Tap the trash can to permanently delete photos from your device. The red badge shows how many photos are in trash.'**
  String get trashManagementDescription;

  /// Tutorial title for main photo view
  ///
  /// In en, this message translates to:
  /// **'Main Photo View'**
  String get mainPhotoView;

  /// Tutorial description for main photo view
  ///
  /// In en, this message translates to:
  /// **'Swipe left/right to compare photos. Tap to show base photo overlay for better comparison.'**
  String get mainPhotoViewDescription;

  /// Tutorial title for action buttons
  ///
  /// In en, this message translates to:
  /// **'Action Buttons'**
  String get actionButtons;

  /// Tutorial description for action buttons
  ///
  /// In en, this message translates to:
  /// **'Swipe to navigate photos. Use \'Set as Base\' or \'Delete\' buttons to organize the currently viewed photo.'**
  String get actionButtonsDescription;

  /// Dialog title for going back to home
  ///
  /// In en, this message translates to:
  /// **'Go Back to Home'**
  String get goBackToHome;

  /// Dialog content for go back confirmation
  ///
  /// In en, this message translates to:
  /// **'Going back will clear your base photo and reset your session. Are you sure?'**
  String get goBackConfirmation;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Trash dialog title
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// Empty trash message
  ///
  /// In en, this message translates to:
  /// **'Trash is empty'**
  String get trashEmpty;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Delete from device dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete from Device'**
  String get deleteFromDevice;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Change base photo dialog title
  ///
  /// In en, this message translates to:
  /// **'Change Base Photo'**
  String get changeBasePhoto;

  /// Change base photo confirmation message
  ///
  /// In en, this message translates to:
  /// **'Do you want to set this image as the new base photo?'**
  String get changeBasePhotoConfirmation;

  /// Change button text
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Delete confirmation with count
  ///
  /// In en, this message translates to:
  /// **'Do you want to permanently delete {count} photo(s) from your device album?'**
  String deleteConfirmation(int count);

  /// Delete success message
  ///
  /// In en, this message translates to:
  /// **'Photos permanently deleted from device'**
  String get photosDeleted;

  /// Base photo change success message
  ///
  /// In en, this message translates to:
  /// **'Base photo changed successfully'**
  String get basePhotoChanged;

  /// No photo placeholder text
  ///
  /// In en, this message translates to:
  /// **'No Photo'**
  String get noPhoto;

  /// Photo comparison header title
  ///
  /// In en, this message translates to:
  /// **'Photo Comparison'**
  String get photoComparison;

  /// Base photo label
  ///
  /// In en, this message translates to:
  /// **'Base Photo'**
  String get basePhoto;

  /// Comparison photo label
  ///
  /// In en, this message translates to:
  /// **'Comparison Photo'**
  String get comparisonPhoto;

  /// Close instruction text
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to close'**
  String get tapAnywhereToClose;

  /// Photo navigation tutorial title
  ///
  /// In en, this message translates to:
  /// **'Photo Navigation'**
  String get photoNavigation;

  /// Photo navigation instruction text
  ///
  /// In en, this message translates to:
  /// **'Swipe through photos above or tap thumbnails to navigate.\\nUse buttons below to organize the current photo.'**
  String get photoNavigationDescription;

  /// Dynamic image number label
  ///
  /// In en, this message translates to:
  /// **'Image {number}'**
  String imageNumber(int number);

  /// Is base button text
  ///
  /// In en, this message translates to:
  /// **'Is Base'**
  String get isBase;

  /// Set as base button text
  ///
  /// In en, this message translates to:
  /// **'Set as Base'**
  String get setAsBase;

  /// Already base photo error message
  ///
  /// In en, this message translates to:
  /// **'This is already the base photo'**
  String get alreadyBasePhoto;

  /// No comparison photos error message
  ///
  /// In en, this message translates to:
  /// **'No comparison photos available'**
  String get noComparisonPhotos;

  /// Cannot delete base photo error message
  ///
  /// In en, this message translates to:
  /// **'Cannot delete base photo'**
  String get cannotDeleteBase;

  /// No comparison photos to delete error message
  ///
  /// In en, this message translates to:
  /// **'No comparison photos to delete'**
  String get noComparisonToDelete;

  /// Protected button text
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protected;

  /// Loading photos message
  ///
  /// In en, this message translates to:
  /// **'Loading photos...'**
  String get loadingPhotos;

  /// Finding photos loading description
  ///
  /// In en, this message translates to:
  /// **'Finding photos around your base image'**
  String get findingPhotos;

  /// Load more indicator
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// Preparing photos message
  ///
  /// In en, this message translates to:
  /// **'Preparing photos...'**
  String get preparingPhotos;

  /// Context message for photos around base
  ///
  /// In en, this message translates to:
  /// **'Photos around your base image'**
  String get photosAroundBase;

  /// Selection counter text
  ///
  /// In en, this message translates to:
  /// **'{selected}/30 selected'**
  String selectionCounter(int selected);

  /// No photos found empty state
  ///
  /// In en, this message translates to:
  /// **'No photos found'**
  String get noPhotosFound;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Done button with count
  ///
  /// In en, this message translates to:
  /// **'Done ({count}/30)'**
  String doneWithCount(int count);

  /// Done button with selected count
  ///
  /// In en, this message translates to:
  /// **'Done ({count})'**
  String doneWithSelectedCount(int count);

  /// Maximum photos selection warning
  ///
  /// In en, this message translates to:
  /// **'Maximum 30 photos can be selected'**
  String get maxPhotosSelected;

  /// Error processing photos message
  ///
  /// In en, this message translates to:
  /// **'Error processing photos: {error}'**
  String errorProcessingPhotos(String error);

  /// Switch albums tutorial title
  ///
  /// In en, this message translates to:
  /// **'Switch Albums'**
  String get switchAlbums;

  /// Switch albums tutorial description
  ///
  /// In en, this message translates to:
  /// **'Tap here to switch between different photo albums on your device.'**
  String get switchAlbumsDescription;

  /// Selection counter tutorial title
  ///
  /// In en, this message translates to:
  /// **'Selection Counter'**
  String get selectionCounterTitle;

  /// Selection counter tutorial description
  ///
  /// In en, this message translates to:
  /// **'Keep track of how many photos you\'ve selected. You can select up to 30 photos at once.'**
  String get selectionCounterDescription;

  /// Select photos tutorial title
  ///
  /// In en, this message translates to:
  /// **'Select Photos'**
  String get selectPhotosTitle;

  /// Select photos tutorial description
  ///
  /// In en, this message translates to:
  /// **'Tap photos to select them. Photos with a red border and \'BASE\' label cannot be selected as they\'re your base photo.'**
  String get selectPhotosDescription;

  /// Confirm selection tutorial title
  ///
  /// In en, this message translates to:
  /// **'Confirm Selection'**
  String get confirmSelection;

  /// Confirm selection tutorial description
  ///
  /// In en, this message translates to:
  /// **'When you\'re done selecting photos, tap this button to add them to your comparison collection.'**
  String get confirmSelectionDescription;

  /// Select base photo tutorial title and gallery title
  ///
  /// In en, this message translates to:
  /// **'Select Base Photo'**
  String get selectBasePhoto;

  /// Select base photo tutorial description
  ///
  /// In en, this message translates to:
  /// **'Start by selecting a base photo that you want to compare with other photos. This will be your reference image.'**
  String get selectBasePhotoDescription;

  /// Add comparison photos tutorial title
  ///
  /// In en, this message translates to:
  /// **'Add Comparison Photos'**
  String get addComparisonPhotos;

  /// Add comparison photos tutorial description
  ///
  /// In en, this message translates to:
  /// **'After selecting a base photo, use this button to add photos for comparison. You can select up to 30 photos at once!'**
  String get addComparisonPhotosDescription;

  /// View and compare photos tutorial title
  ///
  /// In en, this message translates to:
  /// **'View and Compare Photos'**
  String get viewAndComparePhotos;

  /// View and compare photos tutorial description
  ///
  /// In en, this message translates to:
  /// **'Swipe through your photos to compare them. Your base photo will be marked with a \'BASE\' label. Swipe up on any photo to delete it.'**
  String get viewAndComparePhotosDescription;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// Add comparison photo gallery title
  ///
  /// In en, this message translates to:
  /// **'Add Comparison Photo'**
  String get addComparisonPhoto;

  /// Add multiple photos gallery title
  ///
  /// In en, this message translates to:
  /// **'Add Multiple Photos'**
  String get addMultiplePhotos;

  /// Select photos with first as base gallery title
  ///
  /// In en, this message translates to:
  /// **'Select Photos (First will be Base)'**
  String get selectPhotosFirstBase;

  /// Google login button text
  ///
  /// In en, this message translates to:
  /// **'GOOGLE_LOGIN'**
  String get googleLogin;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
