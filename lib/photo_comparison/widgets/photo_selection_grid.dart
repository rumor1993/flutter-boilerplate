import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';

class PhotoSelectionGrid extends ConsumerWidget {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Photos to Compare',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 80, // Fixed width to prevent layout shift (36 + 8 + 36)
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildRestoreButton(context, ref),
                        const SizedBox(width: 8),
                        _buildCurrentPhotoDeleteButton(ref),
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


  Widget _buildRestoreButton(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoProvider);
    
    if (photoState.trashPhotos.isEmpty) {
      return const SizedBox(width: 36, height: 36); // Reserve space even when hidden
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
            const Icon(
              Icons.restore,
              color: Colors.green,
              size: 20,
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
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
    final isBasePhoto = currentIndex == 0 && photoState.basePhoto != null;
    
    if (isBasePhoto || photoState.comparisonPhotos.isEmpty) {
      return const SizedBox(width: 36, height: 36); // Reserve space even when hidden
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
        child: const Icon(
          Icons.delete_outline,
          color: Colors.red,
          size: 20,
        ),
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
    final isBasePhoto = currentIndex == 0 && photoState.basePhoto != null;
    
    if (isBasePhoto) return;
    
    final comparisonIndex = currentIndex - (photoState.basePhoto != null ? 1 : 0);
    
    if (comparisonIndex >= 0 && comparisonIndex < photoState.comparisonPhotos.length) {
      // Move to trash
      ref.read(photoProvider.notifier).moveComparisonPhotoToTrash(comparisonIndex);
      
      // Calculate new total photos after deletion
      final newComparisonCount = photoState.comparisonPhotos.length - 1;
      final newTotalPhotos = (photoState.basePhoto != null ? 1 : 0) + newComparisonCount;
      
      // Adjust page index after deletion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients && newTotalPhotos > 0) {
          int newIndex = currentIndex;
          
          // If we deleted the last photo, move to the previous one
          if (currentIndex >= newTotalPhotos) {
            newIndex = newTotalPhotos - 1;
          }
          
          // Update parent's currentIndex
          onIndexChanged(newIndex);
          
          pageController.animateToPage(
            newIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
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
        final isSelected = isBasePhoto ? (currentIndex == 0) : (selectedPhotos.contains(comparisonIndex) || currentIndex == index);

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
    File photo,
    int index,
    bool isBasePhoto,
    int comparisonIndex,
    bool isSelected,
    List<int> selectedPhotos,
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
              height: 90,
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
                    // Check mark for base photo (always shown) and selected comparison photos
                    if ((isBasePhoto) || (!isBasePhoto && selectedPhotos.contains(comparisonIndex)))
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