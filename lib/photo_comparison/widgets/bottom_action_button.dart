import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';

class BottomActionButton extends ConsumerWidget {
  const BottomActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPhotos = ref.watch(selectedPhotosProvider);

    return Container(
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
              await ref.read(photoProvider.notifier).addMultipleComparisonPhotos();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedPhotos.isNotEmpty
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
    );
  }
}