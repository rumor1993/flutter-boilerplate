import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';

class MainPhotoDisplay extends ConsumerStatefulWidget {
  final PageController pageController;
  final int currentIndex;
  final bool showBasePhoto;
  final Function(int) onPageChanged;
  final Function(int) onSwipeDelete;
  final Function(bool) onShowBasePhotoChanged;

  const MainPhotoDisplay({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.showBasePhoto,
    required this.onPageChanged,
    required this.onSwipeDelete,
    required this.onShowBasePhotoChanged,
  });

  @override
  ConsumerState<MainPhotoDisplay> createState() => _MainPhotoDisplayState();
}

class _MainPhotoDisplayState extends ConsumerState<MainPhotoDisplay>
    with TickerProviderStateMixin {
  late AnimationController _swipeAnimationController;
  late Animation<Offset> _swipeAnimation;
  bool _isSwipeInProgress = false;
  int? _swipeIndex;
  Timer? _basePhotoTimer;

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
    _swipeAnimationController.dispose();
    _basePhotoTimer?.cancel();
    super.dispose();
  }

  void _handleSwipeDelete(int index) async {
    setState(() {
      _isSwipeInProgress = true;
      _swipeIndex = index;
    });
    
    // 스와이프 삭제 중에는 베이스 이미지 오버레이 숨김
    widget.onShowBasePhotoChanged(false);

    await _swipeAnimationController.forward();
    widget.onSwipeDelete(index);

    setState(() {
      _isSwipeInProgress = false;
      _swipeIndex = null;
    });
    _swipeAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final photoState = ref.watch(photoProvider);

    // Create a combined list with base photo first, then comparison photos
    List<File> allPhotos = [];
    if (photoState.basePhoto != null) {
      allPhotos.add(photoState.basePhoto as File);
    }
    allPhotos.addAll(photoState.comparisonPhotos.cast<File>());

    return Expanded(
      flex: 5,
      child: Container(
        width: double.infinity,
        color: const Color(0xFFF5F5F5),
        child: allPhotos.isEmpty
            ? _buildEmptyState()
            : _buildPhotoView(allPhotos, photoState),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: 200,
        height: 250,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildPhotoView(List<File> allPhotos, PhotoState photoState) {
    return Stack(
      children: [
        // Main PageView
        PageView.builder(
          controller: widget.pageController,
          onPageChanged: widget.onPageChanged,
          itemCount: allPhotos.length,
          itemBuilder: (context, index) {
            final photo = allPhotos[index];
            return _buildPhotoItem(photo, index, photoState);
          },
        ),

        // Base photo overlay (스와이프 삭제 중이 아닐 때만 표시)
        if (widget.showBasePhoto &&
            photoState.basePhoto != null &&
            widget.currentIndex > 0 &&
            !_isSwipeInProgress)
          _buildBasePhotoOverlay(photoState),

        // Page indicator
        if (allPhotos.length > 1) _buildPageIndicator(allPhotos, photoState),
      ],
    );
  }

  Widget _buildPhotoItem(File photo, int index, PhotoState photoState) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onPanDown: (details) {
          if (photoState.basePhoto != null && index > 0) {
            // 500ms 딜레이 후에 베이스 이미지 표시
            _basePhotoTimer = Timer(const Duration(milliseconds: 500), () {
              widget.onShowBasePhotoChanged(true);
            });
          }
        },
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy < -500) {
            _handleSwipeDelete(index);
          } else {
            widget.onShowBasePhotoChanged(false);
          }
        },
        onPanCancel: () {
          widget.onShowBasePhotoChanged(false);
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
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
  }

  Widget _buildBasePhotoOverlay(PhotoState photoState) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildPageIndicator(List<File> allPhotos, PhotoState photoState) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          allPhotos.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.currentIndex == index
                  ? (index == 0 && photoState.basePhoto != null
                      ? Colors.blue
                      : Colors.black)
                  : Colors.grey.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}