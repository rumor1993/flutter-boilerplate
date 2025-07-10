import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/widgets/photo_comparison_header.dart';
import 'package:photo_app/photo_comparison/widgets/main_photo_display.dart';
import 'package:photo_app/photo_comparison/widgets/photo_selection_grid.dart';
import 'package:photo_app/photo_comparison/widgets/bottom_action_button.dart';
import 'package:photo_app/photo_comparison/widgets/side_by_side_comparison.dart';
import 'package:photo_app/common/service/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final selectedPhotosProvider =
    StateNotifierProvider<SelectedPhotosNotifier, List<int>>((ref) {
      return SelectedPhotosNotifier();
    });

class SelectedPhotosNotifier extends StateNotifier<List<int>> {
  SelectedPhotosNotifier() : super([]);

  void toggleSelection(int index) {
    if (state.contains(index)) {
      state = state.where((i) => i != index).toList();
    } else {
      state = [...state, index];
    }
  }

  void clearSelection() {
    state = [];
  }
}

class PhotoComparisonScreen extends ConsumerStatefulWidget {
  const PhotoComparisonScreen({super.key});

  @override
  ConsumerState<PhotoComparisonScreen> createState() =>
      _PhotoComparisonScreenState();
}

class _PhotoComparisonScreenState extends ConsumerState<PhotoComparisonScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showBasePhoto = false;
  bool _showSideBySideComparison = false;
  final GlobalKey _mainPhotoKey = GlobalKey();
  final GlobalKey _gridKey = GlobalKey();
  final GlobalKey _bottomActionKey = GlobalKey();
  final GlobalKey _trashKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkAndShowTutorial() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await TutorialService.isFirstTimeUser('photo_comparison')) {
        await Future.delayed(const Duration(milliseconds: 500));
        _showTutorial();
      }
    });
  }

  void _showTutorial() {
    final targets = [
      TargetFocus(
        identify: "trashCan",
        keyTarget: _trashKey,
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Trash Management",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tap the trash can to permanently delete photos from your device. The red badge shows how many photos are in trash.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: () => controller.next(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Next",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "mainPhoto",
        keyTarget: _mainPhotoKey,
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
                    const Text(
                      "Main Photo View",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Swipe left/right to compare photos. Tap to show base photo overlay for better comparison.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => controller.next(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4285F4), Color(0xFF1976D2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "bottomAction",
        keyTarget: _bottomActionKey,
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
                    Transform.translate(
                      offset: const Offset(0, -120),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Action Buttons",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Swipe to navigate photos. Use 'Set as Base' or 'Delete' buttons to organize the currently viewed photo.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: GestureDetector(
                                onTap: () => controller.next(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Got it!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];
    
    TutorialService.showTutorial(
      context: context,
      targets: targets,
      onFinish: () {
        TutorialService.setFirstTimeComplete('photo_comparison');
      },
      onSkip: () {
        TutorialService.setFirstTimeComplete('photo_comparison');
      },
    );
  }


  void _showBackConfirmation(BuildContext context) {
    final photoState = ref.read(photoProvider);
    final hasPhotos = photoState.basePhoto != null || 
                     photoState.comparisonPhotos.isNotEmpty || 
                     photoState.trashPhotos.isNotEmpty;
    
    if (!hasPhotos) {
      // No photos to lose, just go back
      Navigator.pop(context);
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Go Back to Home',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Going back will clear your base photo and reset your session. Are you sure?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              ref.read(photoProvider.notifier).clearAllPhotos();
              Navigator.pop(context); // Go back to home
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _showTrashManagement(BuildContext context) {
    final photoState = ref.read(photoProvider);
    
    if (photoState.trashPhotos.isEmpty) {
      // Show empty trash message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Trash',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Trash is empty',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Show confirmation dialog for deleting from device
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete from Device',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Do you want to permanently delete ${photoState.trashPhotos.length} photo(s) from your device album?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await ref.read(photoProvider.notifier).deleteTrashPhotosPermanently();
              
              // Clear all photos and return to home after deleting from device
              ref.read(photoProvider.notifier).clearAllPhotos();
              navigator.pop(); // Go back to home screen
              
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Photos permanently deleted from device'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChangeCurrentToBaseConfirmation(BuildContext context) {
    if (_currentIndex <= 0) return;

    final comparisonIndex = _currentIndex - 1; // Adjust for base photo at index 0

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Change Base Photo',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Do you want to set this image as the new base photo?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final photoNotifier = ref.read(photoProvider.notifier);
              photoNotifier.changeBasePhoto(comparisonIndex);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Base photo changed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              // Move to base photo (index 0) after changing
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text(
              'Change',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _showBasePhoto = false;
      _showSideBySideComparison = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set context for photo provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(photoProvider.notifier).setContext(context);
    });
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showBackConfirmation(context);
        }
      },
      child: Stack(
        children: [
          Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                // Header Section
                PhotoComparisonHeader(
                  key: _trashKey,
                  currentIndex: _currentIndex,
                  onBack: () => _showBackConfirmation(context),
                  onChangeBase: () => _showChangeCurrentToBaseConfirmation(context),
                  onDeleteAll: () => _showTrashManagement(context),
                  onShowTutorial: () => _showTutorial(),
                ),

                // Main Photo Display
                Container(
                  key: _mainPhotoKey,
                  child: MainPhotoDisplay(
                    pageController: _pageController,
                    currentIndex: _currentIndex,
                    showBasePhoto: _showBasePhoto,
                    onPageChanged: _onPageChanged,
                    onShowBasePhotoChanged: (show) {
                      setState(() {
                        _showBasePhoto = show;
                      });
                    },
                  ),
                ),

                // Photo Selection Grid
                Container(
                  key: _gridKey,
                  child: PhotoSelectionGrid(
                    pageController: _pageController,
                    onChangeBase: () => _showChangeCurrentToBaseConfirmation(context),
                    currentIndex: _currentIndex,
                    onIndexChanged: (newIndex) {
                      setState(() {
                        _currentIndex = newIndex;
                      });
                    },
                  ),
                ),

                // Bottom Action Button
                Container(
                  key: _bottomActionKey,
                  child: BottomActionButton(
                    currentIndex: _currentIndex,
                    pageController: _pageController,
                    onIndexChanged: (newIndex) {
                      setState(() {
                        _currentIndex = newIndex;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Side by side comparison overlay
        if (_showSideBySideComparison)
          SideBySideComparison(
            currentIndex: _currentIndex,
            onClose: () {
              setState(() {
                _showSideBySideComparison = false;
              });
            },
          ),
      ],
      ),
    );
  }
}