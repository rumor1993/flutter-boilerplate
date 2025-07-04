import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_app/common/provider/photo_provider.dart';

class PhotoComparisonHeader extends ConsumerWidget {
  final int currentIndex;
  final VoidCallback onBack;
  final VoidCallback onChangeBase;
  final VoidCallback onDeleteAll;

  const PhotoComparisonHeader({
    super.key,
    required this.currentIndex,
    required this.onBack,
    required this.onChangeBase,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoProvider);

    return Container(
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
              onPressed: onBack,
            ),
            Row(
              children: [
                // 베이스 이미지 변경 버튼
                if (photoState.basePhoto != null && currentIndex > 0)
                  IconButton(
                    icon: const Icon(
                      Icons.swap_horiz,
                      color: Colors.blue,
                    ),
                    onPressed: onChangeBase,
                    tooltip: 'Change Base Photo',
                  ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: onDeleteAll,
                    ),
                    if (photoState.trashPhotos.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${photoState.trashPhotos.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}