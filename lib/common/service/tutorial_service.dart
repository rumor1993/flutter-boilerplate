import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialService {
  static const String _keyFirstTime = 'first_time_app';
  static const String _keyPhotoTutorial = 'photo_tutorial_shown';

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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Base Photo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Start by selecting a base photo that you want to compare with other photos. This will be your reference image.",
                      style: TextStyle(
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add Comparison Photos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "After selecting a base photo, use this button to add photos for comparison. You can select up to 30 photos at once!",
                      style: TextStyle(
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View and Compare Photos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Swipe through your photos to compare them. Your base photo will be marked with a 'BASE' label. Swipe up on any photo to delete it.",
                      style: TextStyle(
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
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Switch Albums",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap here to switch between different photo albums on your device.",
                      style: TextStyle(
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
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selection Counter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Keep track of how many photos you've selected. You can select up to 30 photos at once.",
                      style: TextStyle(
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
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Photos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap photos to select them. Photos with a red border and 'BASE' label cannot be selected as they're your base photo.",
                      style: TextStyle(
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
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm Selection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "When you're done selecting photos, tap this button to add them to your comparison collection.",
                      style: TextStyle(
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

  static void showTutorial({
    required BuildContext context,
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withValues(alpha: 0.8),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onClickTarget: (target) {
        onFinish?.call();
      },
      onClickOverlay: (target) {
        onFinish?.call();
      },
      onFinish: () {
        onFinish?.call();
      },
      onSkip: () {
        onSkip?.call();
        return true;
      },
    ).show(context: context);
  }

  static Future<void> resetAllTutorials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, true);
    await prefs.setBool(_keyPhotoTutorial, true);
  }
}