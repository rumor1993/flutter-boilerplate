import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_app/common/provider/photo_provider.dart';

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

class _PhotoComparisonScreenState extends ConsumerState<PhotoComparisonScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showBasePhoto = false;
  bool _showSideBySideComparison = false;
  
  // 스와이프 애니메이션을 위한 변수들
  late AnimationController _swipeAnimationController;
  late Animation<Offset> _swipeAnimation;
  bool _isSwipeInProgress = false;
  int? _swipeIndex;

  @override
  void initState() {
    super.initState();
    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _swipeAnimationController.dispose();
    super.dispose();
  }

  void _handleSwipeDelete(int index) async {
    final photoState = ref.read(photoProvider);
    
    setState(() {
      _isSwipeInProgress = true;
      _swipeIndex = index;
    });
    
    await _swipeAnimationController.forward();
    
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
    
    // Reset animation
    setState(() {
      _isSwipeInProgress = false;
      _swipeIndex = null;
    });
    _swipeAnimationController.reset();
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

    final comparisonIndex =
        _currentIndex - 1; // Adjust for base photo at index 0

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    final selectedPhotos = ref.watch(selectedPhotosProvider);
    final photoState = ref.watch(photoProvider);

    // Create a combined list with base photo first, then comparison photos
    List<File> allPhotos = [];
    if (photoState.basePhoto != null) {
      allPhotos.add(photoState.basePhoto as File);
    }
    allPhotos.addAll(photoState.comparisonPhotos.cast<File>());

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                // Header Section
                Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            // 베이스 이미지 변경 버튼
                            if (photoState.basePhoto != null &&
                                _currentIndex > 0)
                              IconButton(
                                icon: const Icon(
                                  Icons.swap_horiz,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => _showChangeCurrentToBaseConfirmation(
                                      context,
                                    ),
                                tooltip: 'Change Base Photo',
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showDeleteAllConfirmation(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Photo Display with PageView (확대된 크기)
                Expanded(
                  flex: 5, // 3에서 5로 확대
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF5F5F5),
                    child:
                        allPhotos.isEmpty
                            ? Center(
                              child: Container(
                                width: 200, // 160에서 200으로 확대
                                height: 250, // 200에서 250으로 확대
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFE8F4FD),
                                          Color(0xFFD1E7FC),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Color(0xFF6B7280),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'No Photo',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : Stack(
                              children: [
                                // Main PageView
                                PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentIndex = index;
                                      _showBasePhoto = false;
                                      _showSideBySideComparison = false;
                                    });
                                  },
                                  itemCount: allPhotos.length,
                                  itemBuilder: (context, index) {
                                    final photo = allPhotos[index];

                                    return Container(
                                      margin: const EdgeInsets.all(16),
                                      child: GestureDetector(
                                        onPanDown: (details) {
                                          // 손가락 닿을 때 베이스 이미지 표시 (비교 이미지인 경우만)
                                          if (photoState.basePhoto != null &&
                                              index > 0) {
                                            setState(() {
                                              _showBasePhoto = true;
                                              _showSideBySideComparison = false;
                                            });
                                          }
                                        },
                                        onPanEnd: (details) {
                                          // 위로 스와이프 속도가 충분히 빠르면 삭제
                                          if (details.velocity.pixelsPerSecond.dy < -500) {
                                            _handleSwipeDelete(index);
                                          } else {
                                            // 손가락 뗄 때 베이스 이미지 숨김
                                            setState(() {
                                              _showBasePhoto = false;
                                            });
                                          }
                                        },
                                        onPanCancel: () {
                                          // 제스처 취소 시 베이스 이미지 숨김
                                          setState(() {
                                            _showBasePhoto = false;
                                          });
                                        },
                                        child: AnimatedBuilder(
                                          animation: _swipeAnimation,
                                          builder: (context, child) {
                                            return Transform.translate(
                                              offset: _isSwipeInProgress && _swipeIndex == index
                                                  ? _swipeAnimation.value * 300
                                                  : Offset.zero,
                                              child: Opacity(
                                                opacity: _isSwipeInProgress && _swipeIndex == index
                                                    ? 1.0 - _swipeAnimationController.value
                                                    : 1.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(
                                                      12,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withValues(
                                                          alpha: 0.1,
                                                        ),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(
                                                      12,
                                                    ),
                                                    child: Image.file(
                                                      photo,
                                                      fit: BoxFit.contain,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Base photo overlay (현재 이미지 크기에 맞춰서)
                                if (_showBasePhoto &&
                                    photoState.basePhoto != null &&
                                    _currentIndex > 0)
                                  Container(
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        photoState.basePhoto as File,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),

                                // Page indicator
                                if (allPhotos.length > 1)
                                  Positioned(
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        allPhotos.length,
                                        (index) => Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                _currentIndex == index
                                                    ? (index == 0 &&
                                                            photoState
                                                                    .basePhoto !=
                                                                null
                                                        ? Colors.blue
                                                        : Colors.black)
                                                    : Colors.grey.withValues(
                                                      alpha: 0.5,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                  ),
                ),

                // Selection Section (크기 조정)
                Expanded(
                  flex: 2, // 비율 유지
                  child: Container(
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
                          child: Text(
                            'Choose Photos to Compare',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Photo Grid (베이스 이미지도 포함하여 표시)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child:
                                allPhotos.isEmpty
                                    ? const Center(
                                      child: Text(
                                        'No photos selected.\nTap "Add Photos" to select images.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                    : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allPhotos.length,
                                      itemBuilder: (context, index) {
                                        final isBasePhoto =
                                            index == 0 &&
                                            photoState.basePhoto != null;
                                        final comparisonIndex =
                                            isBasePhoto
                                                ? -1
                                                : index -
                                                    (photoState.basePhoto !=
                                                            null
                                                        ? 1
                                                        : 0);
                                        final isSelected =
                                            isBasePhoto
                                                ? true
                                                : selectedPhotos.contains(
                                                  comparisonIndex,
                                                );

                                        return GestureDetector(
                                          onTap: () {
                                            // Navigate to specific photo in PageView
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          onLongPress: () {
                                            // Toggle selection on long press (비교 이미지만)
                                            if (!isBasePhoto) {
                                              ref
                                                  .read(
                                                    selectedPhotosProvider
                                                        .notifier,
                                                  )
                                                  .toggleSelection(
                                                    comparisonIndex,
                                                  );
                                            } else {
                                              // 베이스 이미지 롱프레스 시 변경 다이얼로그 표시
                                              _showChangeCurrentToBaseConfirmation(
                                                context,
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: 90,
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border:
                                                        isSelected
                                                            ? Border.all(
                                                              color:
                                                                  isBasePhoto
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .blue,
                                                              width: 2,
                                                            )
                                                            : null,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Stack(
                                                      children: [
                                                        Image.file(
                                                          allPhotos[index],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                        if (isSelected)
                                                          Positioned(
                                                            top: 4,
                                                            right: 4,
                                                            child: Container(
                                                              width: 16,
                                                              height: 16,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                    color:
                                                                        Colors
                                                                            .blue,
                                                                    shape:
                                                                        BoxShape
                                                                            .circle,
                                                                  ),
                                                              child: const Icon(
                                                                Icons.check,
                                                                size: 10,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        // Remove button (비교 이미지만)
                                                        if (!isBasePhoto)
                                                          Positioned(
                                                            top: 4,
                                                            left: 4,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                ref
                                                                    .read(
                                                                      photoProvider
                                                                          .notifier,
                                                                    )
                                                                    .removeComparisonPhoto(
                                                                      comparisonIndex,
                                                                    );
                                                                // Also remove from selection if it was selected
                                                                if (selectedPhotos
                                                                    .contains(
                                                                      comparisonIndex,
                                                                    )) {
                                                                  ref
                                                                      .read(
                                                                        selectedPhotosProvider
                                                                            .notifier,
                                                                      )
                                                                      .toggleSelection(
                                                                        comparisonIndex,
                                                                      );
                                                                }
                                                              },
                                                              child: Container(
                                                                width: 16,
                                                                height: 16,
                                                                decoration: const BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                                child: const Icon(
                                                                  Icons.close,
                                                                  size: 10,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  isBasePhoto
                                                      ? 'Base'
                                                      : 'Image ${comparisonIndex + 1}',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button (Add Photos 기능 통합)
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedPhotos.isNotEmpty) {
                          // Navigate to next screen or process selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Selected ${selectedPhotos.length} photos for comparison',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Add photos if no selection
                          await ref
                              .read(photoProvider.notifier)
                              .addMultipleComparisonPhotos();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedPhotos.isNotEmpty
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF404040),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        selectedPhotos.isNotEmpty
                            ? 'Confirm Selection (${selectedPhotos.length})'
                            : 'Add Photos',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Side by side comparison overlay (꾹 누르기 시)
        if (_showSideBySideComparison &&
            photoState.basePhoto != null &&
            _currentIndex > 0)
          GestureDetector(
            onTap: () {
              setState(() {
                _showSideBySideComparison = false;
              });
            },
            child: Container(
              color: Colors.black,
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Photo Comparison',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Photos side by side
                    Expanded(
                      child: Row(
                        children: [
                          // Base photo
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  const Text(
                                    'Base Photo',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        photoState.basePhoto as File,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Comparison photo
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  const Text(
                                    'Comparison Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        allPhotos[_currentIndex],
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Instruction
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Tap anywhere to close',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
