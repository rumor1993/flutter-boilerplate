import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';
import 'package:photo_app/generated/app_localizations.dart';

class PhotoSelectionGrid extends ConsumerStatefulWidget {
  final PageController pageController;
  final VoidCallback onChangeBase;
  final int currentIndex;
  final Function(int) onIndexChanged;

  const PhotoSelectionGrid({
    super.key,
    required this.pageController,
    required this.onChangeBase,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  ConsumerState<PhotoSelectionGrid> createState() => _PhotoSelectionGridState();
}

class _PhotoSelectionGridState extends ConsumerState<PhotoSelectionGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentIndex();
    });
  }

  @override
  void didUpdateWidget(PhotoSelectionGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToCurrentIndex();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentIndex() {
    if (!_scrollController.hasClients) return;

    const itemWidth = 90.0 + 12.0; // width + margin
    final targetOffset = widget.currentIndex * itemWidth;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollViewWidth = screenWidth - 40; // padding
    final centeredOffset = targetOffset - (scrollViewWidth / 2) + (90.0 / 2);

    _scrollController.animateTo(
      centeredOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPhotos = ref.watch(selectedPhotosProvider);
    final photoState = ref.watch(photoProvider);

    // Create a combined list with base photo first, then comparison photos
    List<PhotoInfo> allPhotos = [];
    if (photoState.basePhoto != null) {
      allPhotos.add(photoState.basePhoto!);
    }
    allPhotos.addAll(photoState.comparisonPhotos);

    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Photo Navigation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 36, // Just for restore button
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildRestoreButton(context, ref),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child:
                    allPhotos.isEmpty
                        ? _buildEmptyState()
                        : _buildPhotoGrid(
                          allPhotos,
                          selectedPhotos,
                          photoState,
                          ref,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreButton(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoProvider);

    if (photoState.trashPhotos.isEmpty) {
      return const SizedBox(
        width: 36,
        height: 36,
      ); // Reserve space even when hidden
    }

    return GestureDetector(
      onTap: () {
        _restoreLastPhoto(ref);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            const Icon(Icons.restore, color: Colors.green, size: 20),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                child: Text(
                  '${photoState.trashPhotos.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPhotoDeleteButton(WidgetRef ref) {
    final photoState = ref.watch(photoProvider);

    // Check if current photo is a comparison photo (not base photo)
    final isBasePhoto = widget.currentIndex == 0 && photoState.basePhoto != null;

    if (isBasePhoto || photoState.comparisonPhotos.isEmpty) {
      return const SizedBox(
        width: 36,
        height: 36,
      ); // Reserve space even when hidden
    }

    return GestureDetector(
      onTap: () {
        _deleteCurrentPhoto(ref);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
      ),
    );
  }

  void _restoreLastPhoto(WidgetRef ref) {
    final photoState = ref.read(photoProvider);

    if (photoState.trashPhotos.isNotEmpty) {
      // Restore the last photo (most recently deleted)
      final lastIndex = photoState.trashPhotos.length - 1;
      ref.read(photoProvider.notifier).restorePhotoFromTrash(lastIndex);
    }
  }

  void _deleteCurrentPhoto(WidgetRef ref) {
    final photoState = ref.read(photoProvider);
    final isBasePhoto = widget.currentIndex == 0 && photoState.basePhoto != null;

    if (isBasePhoto) return;

    final comparisonIndex =
        widget.currentIndex - (photoState.basePhoto != null ? 1 : 0);

    if (comparisonIndex >= 0 &&
        comparisonIndex < photoState.comparisonPhotos.length) {
      // Move to trash
      ref
          .read(photoProvider.notifier)
          .moveComparisonPhotoToTrash(comparisonIndex);

      // Calculate new total photos after deletion
      final newComparisonCount = photoState.comparisonPhotos.length - 1;
      final newTotalPhotos =
          (photoState.basePhoto != null ? 1 : 0) + newComparisonCount;

      // Adjust page index after deletion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.pageController.hasClients && newTotalPhotos > 0) {
          int newIndex = widget.currentIndex;

          // If we deleted the last photo, move to the previous one
          if (widget.currentIndex >= newTotalPhotos) {
            newIndex = newTotalPhotos - 1;
          }

          // Update parent's currentIndex
          widget.onIndexChanged(newIndex);

          widget.pageController.animateToPage(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.photoNavigationDescription,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildPhotoGrid(
    List<PhotoInfo> allPhotos,
    List<int> selectedPhotos,
    PhotoState photoState,
    WidgetRef ref,
  ) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: allPhotos.length,
      itemBuilder: (context, index) {
        final isBasePhoto = index == 0 && photoState.basePhoto != null;
        final comparisonIndex =
            isBasePhoto ? -1 : index - (photoState.basePhoto != null ? 1 : 0);
        final isSelected = false;  // No selection anymore, only current view indicator

        return _buildPhotoItem(
          allPhotos[index],
          index,
          isBasePhoto,
          comparisonIndex,
          isSelected,
          selectedPhotos,
          ref,
        );
      },
    );
  }

  Widget _buildPhotoItem(
    PhotoInfo photoInfo,
    int index,
    bool isBasePhoto,
    int comparisonIndex,
    bool isSelected,
    List<int> selectedPhotos,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onTap: () {
        // Simply navigate to the tapped photo
        widget.pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              height: 75,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.currentIndex == index
                      ? Colors.white  // Currently viewed photo - white border
                      : isSelected
                          ? Colors.blue  // Selected photo - blue border
                          : Colors.transparent,  // Not selected - no border
                  width: widget.currentIndex == index ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    photoInfo.buildImage(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      useThumbnail: true,
                      thumbnailSize: const ThumbnailSize(180, 180),
                    ),
                    // BASE label for base photo
                    if (isBasePhoto)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.base,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
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
              isBasePhoto ? AppLocalizations.of(context)!.base : AppLocalizations.of(context)!.imageNumber(comparisonIndex + 1),
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
