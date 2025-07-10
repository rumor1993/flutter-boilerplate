import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/generated/app_localizations.dart';

class SideBySideComparison extends ConsumerWidget {
  final int currentIndex;
  final VoidCallback onClose;

  const SideBySideComparison({
    super.key,
    required this.currentIndex,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoProvider);

    // Create a combined list with base photo first, then comparison photos
    List<PhotoInfo> allPhotos = [];
    if (photoState.basePhoto != null) {
      allPhotos.add(photoState.basePhoto!);
    }
    allPhotos.addAll(photoState.comparisonPhotos);

    if (photoState.basePhoto == null || 
        currentIndex <= 0 || 
        currentIndex >= allPhotos.length) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.photoComparison,
                  style: const TextStyle(
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
                            Text(
                              AppLocalizations.of(context)!.basePhoto,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: photoState.basePhoto!.buildImage(
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  useThumbnail: false,  // Use full quality for side-by-side comparison
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
                            Text(
                              AppLocalizations.of(context)!.comparisonPhoto,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: allPhotos[currentIndex].buildImage(
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  useThumbnail: false,  // Use full quality for side-by-side comparison
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
                child: Text(
                  AppLocalizations.of(context)!.tapAnywhereToClose,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}