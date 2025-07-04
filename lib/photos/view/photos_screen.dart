import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_app/common/provider/photo_provider.dart';

class PhotosScreen extends ConsumerStatefulWidget {
  const PhotosScreen({super.key});

  @override
  ConsumerState<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends ConsumerState<PhotosScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isFullScreen = false;
  File? _fullScreenImage;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context, int index, PhotoNotifier photoNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Photo',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this photo?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              photoNotifier.removeComparisonPhoto(index);
              Navigator.pop(context);
              // Update current index if needed
              if (index <= _currentIndex && _currentIndex > 0) {
                setState(() {
                  _currentIndex = _currentIndex - 1;
                });
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoState = ref.watch(photoProvider);
    final photoNotifier = ref.read(photoProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (photoState.comparisonPhotos.isEmpty)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your organized photos will appear here',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            SafeArea(
              child: Column(
                children: [
                  // Top bar with add button
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Photos (${photoState.comparisonPhotos.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => photoNotifier.addMultipleComparisonPhotos(),
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                // Show delete confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
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
                                          photoNotifier.clearComparisonPhotos();
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Photo viewer
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemCount: photoState.comparisonPhotos.length,
                      itemBuilder: (context, index) {
                        final photo = photoState.comparisonPhotos[index] as File;
                        return Container(
                          margin: const EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFullScreen = true;
                                _fullScreenImage = photo;
                              });
                            },
                            onPanUpdate: (details) {
                              // Check if swiping up
                              if (details.delta.dy < -5) {
                                _showDeleteConfirmation(context, index, photoNotifier);
                              }
                            },
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
                        );
                      },
                    ),
                  ),
                  
                  // Page indicator
                  if (photoState.comparisonPhotos.length > 1)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          photoState.comparisonPhotos.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          
          // Full screen overlay
          if (_isFullScreen && _fullScreenImage != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFullScreen = false;
                  _fullScreenImage = null;
                });
              },
              child: Container(
                color: Colors.black,
                child: PhotoView(
                  imageProvider: FileImage(_fullScreenImage!),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}