import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/widgets/photo_comparison_header.dart';
import 'package:photo_app/photo_comparison/widgets/main_photo_display.dart';
import 'package:photo_app/photo_comparison/widgets/photo_selection_grid.dart';
import 'package:photo_app/photo_comparison/widgets/bottom_action_button.dart';
import 'package:photo_app/photo_comparison/widgets/side_by_side_comparison.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleSwipeDelete(int index) {
    final photoState = ref.read(photoProvider);
    
    if (index == 0 && photoState.basePhoto != null) {
      // 베이스 이미지는 그냥 제거
      ref.read(photoProvider.notifier).clearBasePhoto();
    } else {
      // 비교 이미지는 휴지통으로 이동
      final comparisonIndex = index - (photoState.basePhoto != null ? 1 : 0);
      ref.read(photoProvider.notifier).moveComparisonPhotoToTrash(comparisonIndex);
    }
    
    // Update current index if needed
    if (index <= _currentIndex && _currentIndex > 0) {
      setState(() {
        _currentIndex = _currentIndex - 1;
      });
    }
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete All Photos',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete all photos?',
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
              photoNotifier.clearAllPhotos();
              Navigator.pop(context);
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                // Header Section
                PhotoComparisonHeader(
                  currentIndex: _currentIndex,
                  onBack: () => Navigator.pop(context),
                  onChangeBase: () => _showChangeCurrentToBaseConfirmation(context),
                  onDeleteAll: () => _showDeleteAllConfirmation(context),
                ),

                // Main Photo Display
                MainPhotoDisplay(
                  pageController: _pageController,
                  currentIndex: _currentIndex,
                  showBasePhoto: _showBasePhoto,
                  onPageChanged: _onPageChanged,
                  onSwipeDelete: _handleSwipeDelete,
                  onShowBasePhotoChanged: (show) {
                    setState(() {
                      _showBasePhoto = show;
                    });
                  },
                ),

                // Photo Selection Grid
                PhotoSelectionGrid(
                  pageController: _pageController,
                  onChangeBase: () => _showChangeCurrentToBaseConfirmation(context),
                ),

                // Bottom Action Button
                const BottomActionButton(),
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
    );
  }
}