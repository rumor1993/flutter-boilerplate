import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/generated/app_localizations.dart';

class BottomActionButton extends ConsumerWidget {
  final int currentIndex;
  final PageController? pageController;
  final Function(int)? onIndexChanged;
  
  const BottomActionButton({
    super.key,
    required this.currentIndex,
    this.pageController,
    this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoProvider);
    
    // Calculate if current photo is base photo
    final isBasePhoto = currentIndex == 0 && photoState.basePhoto != null;
    final comparisonIndex = isBasePhoto ? -1 : currentIndex - (photoState.basePhoto != null ? 1 : 0);
    
    // Check if there are comparison photos to work with
    final hasComparisonPhotos = photoState.comparisonPhotos.isNotEmpty;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Set as Base button
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: !isBasePhoto && hasComparisonPhotos
                    ? () {
                        // Set current photo as new base photo
                        final photoNotifier = ref.read(photoProvider.notifier);
                        photoNotifier.changeBasePhoto(comparisonIndex);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.basePhotoChanged),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isBasePhoto 
                                ? AppLocalizations.of(context)!.alreadyBasePhoto
                                : AppLocalizations.of(context)!.noComparisonPhotos),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isBasePhoto && hasComparisonPhotos
                      ? Colors.blue
                      : const Color(0xFF404040),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_horiz, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isBasePhoto ? AppLocalizations.of(context)!.isBase : AppLocalizations.of(context)!.setAsBase,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Move to Trash button
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: !isBasePhoto && hasComparisonPhotos
                    ? () {
                        // Move current photo to trash
                        final photoNotifier = ref.read(photoProvider.notifier);
                        photoNotifier.moveComparisonPhotoToTrash(comparisonIndex);
                        
                        // Calculate new total photos after deletion
                        final newComparisonCount = photoState.comparisonPhotos.length - 1;
                        final newTotalPhotos = (photoState.basePhoto != null ? 1 : 0) + newComparisonCount;
                        
                        // Adjust page index after deletion
                        if (pageController != null && onIndexChanged != null && newTotalPhotos > 0) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (pageController!.hasClients) {
                              int newIndex = currentIndex;
                              
                              // If we deleted the last photo, move to the previous one
                              if (currentIndex >= newTotalPhotos) {
                                newIndex = newTotalPhotos - 1;
                              }
                              
                              // Update parent's currentIndex
                              onIndexChanged!(newIndex);
                              
                              pageController!.animateToPage(
                                newIndex,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          });
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isBasePhoto 
                                ? AppLocalizations.of(context)!.cannotDeleteBase
                                : AppLocalizations.of(context)!.noComparisonToDelete),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isBasePhoto && hasComparisonPhotos
                      ? Colors.red
                      : const Color(0xFF404040),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isBasePhoto ? AppLocalizations.of(context)!.protected : AppLocalizations.of(context)!.delete,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}