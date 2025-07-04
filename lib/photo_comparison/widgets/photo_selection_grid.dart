import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';

class PhotoSelectionGrid extends ConsumerWidget {
  final PageController pageController;
  final VoidCallback onChangeBase;

  const PhotoSelectionGrid({
    super.key,
    required this.pageController,
    required this.onChangeBase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPhotos = ref.watch(selectedPhotosProvider);
    final photoState = ref.watch(photoProvider);

    // Create a combined list with base photo first, then comparison photos
    List<File> allPhotos = [];
    if (photoState.basePhoto != null) {
      allPhotos.add(photoState.basePhoto as File);
    }
    allPhotos.addAll(photoState.comparisonPhotos.cast<File>());

    return Expanded(
      flex: 2,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: allPhotos.isEmpty
                    ? _buildEmptyState()
                    : _buildPhotoGrid(allPhotos, selectedPhotos, photoState, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No photos selected.\nTap "Add Photos" to select images.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(
    List<File> allPhotos,
    List<int> selectedPhotos,
    PhotoState photoState,
    WidgetRef ref,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: allPhotos.length,
      itemBuilder: (context, index) {
        final isBasePhoto = index == 0 && photoState.basePhoto != null;
        final comparisonIndex = isBasePhoto
            ? -1
            : index - (photoState.basePhoto != null ? 1 : 0);
        final isSelected = isBasePhoto ? true : selectedPhotos.contains(comparisonIndex);

        return _buildPhotoItem(
          allPhotos[index],
          index,
          isBasePhoto,
          comparisonIndex,
          isSelected,
          ref,
        );
      },
    );
  }

  Widget _buildPhotoItem(
    File photo,
    int index,
    bool isBasePhoto,
    int comparisonIndex,
    bool isSelected,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      onLongPress: () {
        if (!isBasePhoto) {
          ref.read(selectedPhotosProvider.notifier).toggleSelection(comparisonIndex);
        } else {
          onChangeBase();
        }
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: isBasePhoto ? Colors.blue : Colors.blue,
                        width: 2,
                      )
                    : null,
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
                    Image.file(
                      photo,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 10,
                            color: Colors.white,
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
                            ref.read(photoProvider.notifier).removeComparisonPhoto(comparisonIndex);
                            // Also remove from selection if it was selected
                            final selectedPhotos = ref.read(selectedPhotosProvider);
                            if (selectedPhotos.contains(comparisonIndex)) {
                              ref.read(selectedPhotosProvider.notifier).toggleSelection(comparisonIndex);
                            }
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 10,
                              color: Colors.white,
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
              isBasePhoto ? 'Base' : 'Image ${comparisonIndex + 1}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}