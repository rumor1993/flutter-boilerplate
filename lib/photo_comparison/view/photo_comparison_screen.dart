import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class PhotoComparisonScreen extends ConsumerWidget {
  const PhotoComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPhotos = ref.watch(selectedPhotosProvider);
    final photoState = ref.watch(photoProvider);

    return Scaffold(
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
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Main Photo Display
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                child: Center(
                  child: Container(
                    width: 160,
                    height: 200,
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
                      child: photoState.basePhoto != null
                          ? Image.file(
                              photoState.basePhoto!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFE8F4FD), Color(0xFFD1E7FC)],
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
                                      'Base Photo',
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
                ),
              ),
            ),

            // Selection Section
            Expanded(
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

                    // Add Photos Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SizedBox(
                        width: 120,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () async {
                            await ref.read(photoProvider.notifier).addMultipleComparisonPhotos();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF404040),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add Photos',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Photo Grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: photoState.comparisonPhotos.isEmpty
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
                                itemCount: photoState.comparisonPhotos.length,
                                itemBuilder: (context, index) {
                                  final isSelected = selectedPhotos.contains(index);
                                  return GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(selectedPhotosProvider.notifier)
                                          .toggleSelection(index);
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
                                                      color: Colors.blue,
                                                      width: 2,
                                                    )
                                                  : null,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(
                                                    alpha: 0.2,
                                                  ),
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
                                                    photoState.comparisonPhotos[index],
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
                                                        decoration:
                                                            const BoxDecoration(
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
                                                  // Remove button
                                                  Positioned(
                                                    top: 4,
                                                    left: 4,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ref.read(photoProvider.notifier).removeComparisonPhoto(index);
                                                        // Also remove from selection if it was selected
                                                        if (selectedPhotos.contains(index)) {
                                                          ref.read(selectedPhotosProvider.notifier).toggleSelection(index);
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
                                            'Image ${index + 1}',
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

            // Bottom Action Button
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: selectedPhotos.isNotEmpty
                      ? () {
                          // Navigate to next screen or process selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Selected ${selectedPhotos.length} photos for comparison',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPhotos.isNotEmpty
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    selectedPhotos.isNotEmpty
                        ? 'Confirm Selection (${selectedPhotos.length})'
                        : 'Confirm Selection',
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
    );
  }
}