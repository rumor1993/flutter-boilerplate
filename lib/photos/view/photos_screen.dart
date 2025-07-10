import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
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

  Future<bool> _isImageLoaded(PhotoInfo photoInfo) async {
    try {
      if (photoInfo.syncFile != null) {
        return true; // Already cached
      }
      
      // Check if thumbnail is available
      final thumbnail = await photoInfo.getThumbnail();
      return thumbnail != null;
    } catch (e) {
      return false;
    }
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

    // Include all photos including base photo for display
    final displayPhotos = <PhotoInfo>[];
    if (photoState.basePhoto != null) {
      displayPhotos.add(photoState.basePhoto!);
    }
    displayPhotos.addAll(photoState.comparisonPhotos);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (displayPhotos.isEmpty)
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
                          'Photos (${displayPhotos.length})',
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
                      itemCount: displayPhotos.length,
                      itemBuilder: (context, index) {
                        final photoInfo = displayPhotos[index];
                        final isBasePhoto = photoState.basePhoto != null && photoInfo.id == photoState.basePhoto!.id;
                        
                        return Container(
                          margin: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final file = await photoInfo.file;
                                  if (file != null) {
                                    setState(() {
                                      _isFullScreen = true;
                                      _fullScreenImage = file;
                                    });
                                  }
                                },
                                onPanUpdate: (details) {
                                  // Check if swiping up
                                  if (details.delta.dy < -5) {
                                    // Don't allow deletion of base photo
                                    if (!isBasePhoto) {
                                      // Find the actual index in the comparison photos list
                                      final actualIndex = photoState.comparisonPhotos.indexOf(photoInfo);
                                      if (actualIndex != -1) {
                                        _showDeleteConfirmation(context, actualIndex, photoNotifier);
                                      }
                                    }
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      photoInfo.buildImage(
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                        useThumbnail: true,
                                        thumbnailSize: const ThumbnailSize(800, 800),
                                      ),
                                      // Loading overlay
                                      FutureBuilder<bool>(
                                        future: _isImageLoaded(photoInfo),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting || 
                                              (snapshot.hasData && !snapshot.data!)) {
                                            return Container(
                                              color: Colors.black.withValues(alpha: 0.7),
                                              child: const Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Base photo indicator
                              if (isBasePhoto)
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'BASE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Page indicator
                  if (displayPhotos.length > 1)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          displayPhotos.length,
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