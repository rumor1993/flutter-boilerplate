import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:photo_app/generated/app_localizations.dart';

class TutorialService {
  static const String _keyFirstTime = 'first_time_app';
  static const String _keyPhotoTutorial = 'photo_tutorial_shown';

  // Helper function to create tutorial content with next button
  static Widget _buildTutorialContent({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onNext,
    bool isLastStep = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLastStep ? AppLocalizations.of(context)!.gotIt : AppLocalizations.of(context)!.next,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLastStep ? Icons.check : Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> isFirstTimeUser([String? key]) async {
    final prefs = await SharedPreferences.getInstance();
    final prefKey = key != null ? '${_keyFirstTime}_$key' : _keyFirstTime;
    return prefs.getBool(prefKey) ?? true;
  }

  static Future<void> setFirstTimeComplete([String? key]) async {
    final prefs = await SharedPreferences.getInstance();
    final prefKey = key != null ? '${_keyFirstTime}_$key' : _keyFirstTime;
    await prefs.setBool(prefKey, false);
  }

  static Future<bool> shouldShowPhotoTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPhotoTutorial) ?? true;
  }

  static Future<void> setPhotoTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPhotoTutorial, false);
  }

  static List<TargetFocus> createMainAppTutorial({
    required GlobalKey selectBasePhotoKey,
    required GlobalKey addPhotosKey,
    required GlobalKey photosViewKey,
  }) {
    List<TargetFocus> targets = [];

    // 1. Select Base Photo Tutorial
    targets.add(
      TargetFocus(
        identify: "selectBasePhoto",
        keyTarget: selectBasePhotoKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.selectBasePhoto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.selectBasePhotoDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // 2. Add Photos Tutorial
    targets.add(
      TargetFocus(
        identify: "addPhotos",
        keyTarget: addPhotosKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.addComparisonPhotos,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.addComparisonPhotosDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // 3. Photos View Tutorial
    targets.add(
      TargetFocus(
        identify: "photosView",
        keyTarget: photosViewKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.viewAndComparePhotos,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.viewAndComparePhotosDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  static List<TargetFocus> createPhotoGalleryTutorial({
    required GlobalKey albumSelectorKey,
    required GlobalKey photoGridKey,
    required GlobalKey doneButtonKey,
    required GlobalKey selectionCountKey,
  }) {
    List<TargetFocus> targets = [];

    // 1. Album Selector Tutorial
    targets.add(
      TargetFocus(
        identify: "albumSelector",
        keyTarget: albumSelectorKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.switchAlbums,
                description: AppLocalizations.of(context)!.switchAlbumsDescription,
                onNext: () {
                  print("Album selector tutorial - next tapped");
                  controller.next();
                },
              );
            },
          ),
        ],
      ),
    );

    // 2. Selection Count Tutorial
    targets.add(
      TargetFocus(
        identify: "selectionCount",
        keyTarget: selectionCountKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.selectionCounterTitle,
                description: AppLocalizations.of(context)!.selectionCounterDescription,
                onNext: () {
                  print("Selection count tutorial - next tapped");
                  controller.next();
                },
              );
            },
          ),
        ],
      ),
    );

    // 3. Photo Grid Tutorial
    targets.add(
      TargetFocus(
        identify: "photoGrid",
        keyTarget: photoGridKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.selectPhotosTitle,
                description: AppLocalizations.of(context)!.selectPhotosDescription,
                onNext: () {
                  print("Photo grid tutorial - next tapped");
                  controller.next();
                },
              );
            },
          ),
        ],
      ),
    );

    // 4. Done Button Tutorial
    targets.add(
      TargetFocus(
        identify: "doneButton",
        keyTarget: doneButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                context: context,
                title: AppLocalizations.of(context)!.confirmSelection,
                description: AppLocalizations.of(context)!.confirmSelectionDescription,
                onNext: () {
                  print("Done button tutorial - next tapped");
                  controller.next();
                },
                isLastStep: true,
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  static void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    late TutorialCoachMark tutorial;
    
    tutorial = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withValues(alpha: 0.8),
      textSkip: AppLocalizations.of(context)!.skip,
      paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      hideSkip: false,
      useSafeArea: false,
      pulseEnable: false,

      onClickTarget: (target) {
        print("onClickTarget - should trigger original action");
        // Let the target handle its own action naturally
      },
      onClickOverlay: (target) {
        print("onClickOverlay called - moving to next!");
        tutorial.next();
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("onClickTargetWithTapPosition: ${tapDetails.globalPosition}");
      },
      onFinish: () {
        print("Tutorial finished");
        onFinish?.call();
      },
      onSkip: () {
        print("Tutorial skipped");
        onSkip?.call();
        return true;
      },
    );
    
    tutorial.show(context: context);
  }

  static Future<void> resetAllTutorials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, true);
    await prefs.setBool(_keyPhotoTutorial, true);
  }
}