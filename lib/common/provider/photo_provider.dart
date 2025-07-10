import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_app/common/view/photo_gallery_picker.dart';
import 'package:photo_app/generated/app_localizations.dart';

class PhotoInfo {
  final AssetEntity asset;
  final File? _cachedFile;
  final Uint8List? _cachedThumbnail;
  final String? albumId;  // Store which album this photo is from
  final int? indexInAlbum;  // Store position in album

  PhotoInfo({
    required this.asset, 
    File? cachedFile,
    Uint8List? cachedThumbnail,
    this.albumId,
    this.indexInAlbum,
  }) : _cachedFile = cachedFile, _cachedThumbnail = cachedThumbnail;

  String get id => asset.id;

  Future<File?> get file async {
    return _cachedFile ?? await asset.file;
  }

  File? get syncFile => _cachedFile;

  // Get thumbnail data (faster than full file)
  Future<Uint8List?> getThumbnail({
    ThumbnailSize size = const ThumbnailSize(200, 200),
    int quality = 70,
  }) async {
    return _cachedThumbnail ?? await asset.thumbnailDataWithSize(size, quality: quality);
  }

  // For UI components that need immediate file access
  Widget buildImage({
    required BoxFit fit, 
    double? width, 
    double? height,
    bool useThumbnail = false,
    ThumbnailSize thumbnailSize = const ThumbnailSize(200, 200),
    int thumbnailQuality = 70,
  }) {
    if (!useThumbnail && _cachedFile != null) {
      return Image.file(_cachedFile!, fit: fit, width: width, height: height);
    }

    if (useThumbnail && _cachedThumbnail != null) {
      return Image.memory(_cachedThumbnail!, fit: fit, width: width, height: height);
    }

    if (useThumbnail) {
      return FutureBuilder<Uint8List?>(
        future: getThumbnail(size: thumbnailSize, quality: thumbnailQuality),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              fit: fit,
              width: width,
              height: height,
            );
          }
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.loading,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return FutureBuilder<File?>(
      future: asset.file,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(
            snapshot.data!,
            fit: fit,
            width: width,
            height: height,
          );
        }
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.loading,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PhotoState {
  final PhotoInfo? basePhoto;
  final List<PhotoInfo> comparisonPhotos;
  final List<PhotoInfo> trashPhotos;
  final bool isProcessingMultiplePhotos;

  PhotoState({
    this.basePhoto,
    this.comparisonPhotos = const [],
    this.trashPhotos = const [],
    this.isProcessingMultiplePhotos = false,
  });

  PhotoState copyWith({
    PhotoInfo? basePhoto,
    List<PhotoInfo>? comparisonPhotos,
    List<PhotoInfo>? trashPhotos,
    bool? isProcessingMultiplePhotos,
  }) {
    return PhotoState(
      basePhoto: basePhoto ?? this.basePhoto,
      comparisonPhotos: comparisonPhotos ?? this.comparisonPhotos,
      trashPhotos: trashPhotos ?? this.trashPhotos,
      isProcessingMultiplePhotos: isProcessingMultiplePhotos ?? this.isProcessingMultiplePhotos,
    );
  }
}

class PhotoNotifier extends StateNotifier<PhotoState> {
  PhotoNotifier() : super(PhotoState());

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> selectBasePhoto() async {
    if (_context == null) return;

    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        print('Photo permission denied');
        return;
      }

      final result = await Navigator.push<Map<String, dynamic>>(
        _context!,
        MaterialPageRoute(
          builder:
              (context) => PhotoGalleryPicker(
                allowMultiple: false,
                title: AppLocalizations.of(context)!.selectBasePhoto,
                onSelectionChanged: (assets) {},
              ),
        ),
      );

      if (result != null && result['assets'] != null && result['assets'].isNotEmpty) {
        final List<AssetEntity> assets = result['assets'];
        final String? albumId = result['albumId'];
        final asset = assets.first;
        final file = await asset.file;
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
          quality: 70,
        );
        state = state.copyWith(
          basePhoto: PhotoInfo(
            asset: asset, 
            cachedFile: file,
            cachedThumbnail: thumbnail,
            albumId: albumId,
          ),
        );
      }
    } catch (e) {
      print('Error selecting base photo: $e');
    }
  }

  Future<void> addComparisonPhoto() async {
    if (_context == null) return;

    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        print('Photo permission denied');
        return;
      }

      final result = await Navigator.push<Map<String, dynamic>>(
        _context!,
        MaterialPageRoute(
          builder:
              (context) => PhotoGalleryPicker(
                allowMultiple: false,
                title: AppLocalizations.of(context)!.addComparisonPhoto,
                onSelectionChanged: (assets) {},
                disabledAssetId: state.basePhoto?.id,  // Disable base photo from selection
                centerAroundAssetId: state.basePhoto?.id,  // Center around base photo
              ),
        ),
      );

      if (result != null && result['assets'] != null && result['assets'].isNotEmpty) {
        final List<AssetEntity> assets = result['assets'];
        final String? albumId = result['albumId'];
        final asset = assets.first;
        final file = await asset.file;
        final thumbnail = await asset.thumbnailDataWithSize(
          const ThumbnailSize(200, 200),
          quality: 70,
        );
        final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
        currentPhotos.add(PhotoInfo(
          asset: asset, 
          cachedFile: file,
          cachedThumbnail: thumbnail,
          albumId: albumId,
        ));
        state = state.copyWith(comparisonPhotos: currentPhotos);
      }
    } catch (e) {
      print('Error adding comparison photo: $e');
    }
  }

  Future<void> addMultipleComparisonPhotos() async {
    if (_context == null) return;

    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        print('Photo permission denied');
        return;
      }

      final result = await Navigator.push<Map<String, dynamic>>(
        _context!,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryPicker(
            allowMultiple: true,
            title: AppLocalizations.of(context)!.addMultiplePhotos,
            onSelectionChanged: (assets) {},
            disabledAssetId: state.basePhoto?.id,
            centerAroundAssetId: state.basePhoto?.id,  // Center around base photo
          ),
        ),
      );

      if (result != null && result['assets'] != null && result['assets'].isNotEmpty) {
        // Start processing state
        state = state.copyWith(isProcessingMultiplePhotos: true);
        
        final List<AssetEntity> assets = result['assets'];
        final String? albumId = result['albumId'];
        final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
        
        for (final asset in assets) {
          // Check if photo is already in comparison photos
          if (!currentPhotos.any((photo) => photo.id == asset.id)) {
            final file = await asset.file;
            final thumbnail = await asset.thumbnailDataWithSize(
              const ThumbnailSize(200, 200),
              quality: 70,
            );
            currentPhotos.add(PhotoInfo(
              asset: asset,
              cachedFile: file,
              cachedThumbnail: thumbnail,
              albumId: albumId,
            ));
          }
        }
        
        // End processing state and update photos
        state = state.copyWith(
          comparisonPhotos: currentPhotos,
          isProcessingMultiplePhotos: false,
        );
      }
    } catch (e) {
      print('Error adding multiple comparison photos: $e');
      // End processing state on error
      state = state.copyWith(isProcessingMultiplePhotos: false);
    }
  }

  Future<void> selectMultiplePhotosFromHome() async {
    if (_context == null) return;

    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        print('Photo permission denied');
        return;
      }

      // Simply navigate to PhotoGalleryPicker
      // PhotoGalleryPicker will handle the processing and navigation to PhotoComparisonScreen
      await Navigator.push(
        _context!,
        MaterialPageRoute(
          builder: (context) => PhotoGalleryPicker(
            allowMultiple: true,
            title: AppLocalizations.of(context)!.selectPhotosFirstBase,
            onSelectionChanged: (assets) {},
          ),
        ),
      );
    } catch (e) {
      print('Error selecting multiple photos from home: $e');
    }
  }

  void updatePhotos({
    required PhotoInfo basePhoto,
    required List<PhotoInfo> comparisonPhotos,
  }) {
    state = state.copyWith(
      basePhoto: basePhoto,
      comparisonPhotos: comparisonPhotos,
      isProcessingMultiplePhotos: false,
    );
  }

  void removeComparisonPhoto(int index) {
    final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      state = state.copyWith(comparisonPhotos: currentPhotos);
    }
  }

  void moveComparisonPhotoToTrash(int index) {
    final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
    final currentTrash = List<PhotoInfo>.from(state.trashPhotos);

    if (index >= 0 && index < currentPhotos.length) {
      final photoToMove = currentPhotos.removeAt(index);
      currentTrash.add(photoToMove);

      state = state.copyWith(
        comparisonPhotos: currentPhotos,
        trashPhotos: currentTrash,
      );
    }
  }

  void restorePhotoFromTrash(int trashIndex) {
    final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
    final currentTrash = List<PhotoInfo>.from(state.trashPhotos);

    if (trashIndex >= 0 && trashIndex < currentTrash.length) {
      final photoToRestore = currentTrash.removeAt(trashIndex);
      currentPhotos.add(photoToRestore);

      state = state.copyWith(
        comparisonPhotos: currentPhotos,
        trashPhotos: currentTrash,
      );
    }
  }

  void restoreAllFromTrash() {
    final currentPhotos = List<PhotoInfo>.from(state.comparisonPhotos);
    final trashPhotos = List<PhotoInfo>.from(state.trashPhotos);

    currentPhotos.addAll(trashPhotos);

    state = state.copyWith(comparisonPhotos: currentPhotos, trashPhotos: []);
  }

  void clearTrash() {
    state = state.copyWith(trashPhotos: []);
  }

  Future<void> deleteTrashPhotosPermanently() async {
    try {
      final trashPhotos = List<PhotoInfo>.from(state.trashPhotos);

      if (trashPhotos.isEmpty) return;

      // Request permission to access photos
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps != PermissionState.authorized) {
        print('Permission denied for photo access');
        return;
      }

      // Collect all asset IDs for batch deletion
      final List<String> assetIds = trashPhotos.map((photo) => photo.id).toList();

      try {
        // Delete all photos in one batch - this will show only one system alert
        final List<String> result = await PhotoManager.editor.deleteWithIds(assetIds);
        
        if (result.isNotEmpty) {
          print('Successfully deleted ${result.length} photos from gallery');
        }

        // Also delete cached files
        for (final photoInfo in trashPhotos) {
          try {
            final file = await photoInfo.file;
            if (file != null && await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            print('Error deleting cached file ${photoInfo.id}: $e');
            // Continue with next file even if one fails
          }
        }
      } catch (e) {
        print('Error during batch deletion: $e');
      }

      // Clear trash after deletion attempts
      state = state.copyWith(trashPhotos: []);
    } catch (e) {
      print('Error deleting trash photos permanently: $e');
    }
  }

  Future<void> deleteSpecificTrashPhoto(int trashIndex) async {
    try {
      final currentTrash = List<PhotoInfo>.from(state.trashPhotos);

      if (trashIndex >= 0 && trashIndex < currentTrash.length) {
        final photoToDelete = currentTrash[trashIndex];

        // Request permission to access photos
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps == PermissionState.authorized) {
          // Use AssetEntity ID directly for deletion
          final List<String> result = await PhotoManager.editor.deleteWithIds([
            photoToDelete.id,
          ]);
          if (result.isNotEmpty) {
            print('Successfully deleted ${photoToDelete.id} from gallery');
          }
        }

        // Also delete the cached file if it still exists
        final file = await photoToDelete.file;
        if (file != null && await file.exists()) {
          await file.delete();
        }

        currentTrash.removeAt(trashIndex);
        state = state.copyWith(trashPhotos: currentTrash);
      }
    } catch (e) {
      print('Error deleting specific trash photo: $e');
    }
  }

  // Delete multiple selected trash photos at once
  Future<void> deleteSelectedTrashPhotos(List<int> selectedIndices) async {
    try {
      final currentTrash = List<PhotoInfo>.from(state.trashPhotos);
      
      if (selectedIndices.isEmpty) return;
      
      // Validate indices and get photos to delete
      final photosToDelete = <PhotoInfo>[];
      for (final index in selectedIndices) {
        if (index >= 0 && index < currentTrash.length) {
          photosToDelete.add(currentTrash[index]);
        }
      }
      
      if (photosToDelete.isEmpty) return;

      // Request permission to access photos
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps != PermissionState.authorized) {
        print('Permission denied for photo access');
        return;
      }

      // Collect asset IDs for batch deletion
      final List<String> assetIds = photosToDelete.map((photo) => photo.id).toList();

      try {
        // Delete all selected photos in one batch - this will show only one system alert
        final List<String> result = await PhotoManager.editor.deleteWithIds(assetIds);
        
        if (result.isNotEmpty) {
          print('Successfully deleted ${result.length} selected photos from gallery');
        }

        // Also delete cached files
        for (final photoInfo in photosToDelete) {
          try {
            final file = await photoInfo.file;
            if (file != null && await file.exists()) {
              await file.delete();
            }
          } catch (e) {
            print('Error deleting cached file ${photoInfo.id}: $e');
            // Continue with next file even if one fails
          }
        }
      } catch (e) {
        print('Error during batch deletion: $e');
      }

      // Remove deleted photos from trash (sort indices in descending order to avoid index shifting)
      selectedIndices.sort((a, b) => b.compareTo(a));
      for (final index in selectedIndices) {
        if (index >= 0 && index < currentTrash.length) {
          currentTrash.removeAt(index);
        }
      }
      
      state = state.copyWith(trashPhotos: currentTrash);
    } catch (e) {
      print('Error deleting selected trash photos: $e');
    }
  }

  void clearBasePhoto() {
    state = state.copyWith(basePhoto: null);
  }

  void clearComparisonPhotos() {
    state = state.copyWith(comparisonPhotos: []);
  }

  void clearAllPhotos() {
    state = PhotoState();
  }

  void moveAllPhotosToTrash() {
    final currentTrash = List<PhotoInfo>.from(state.trashPhotos);

    // Add base photo to trash if it exists
    if (state.basePhoto != null) {
      currentTrash.add(state.basePhoto!);
    }

    // Add all comparison photos to trash
    currentTrash.addAll(state.comparisonPhotos);

    // Clear all photos and update trash
    state = PhotoState(trashPhotos: currentTrash);
  }

  void changeBasePhoto(int comparisonIndex) {
    final currentComparisonPhotos = List<PhotoInfo>.from(
      state.comparisonPhotos,
    );

    if (comparisonIndex >= 0 &&
        comparisonIndex < currentComparisonPhotos.length) {
      final newBasePhoto = currentComparisonPhotos[comparisonIndex];
      currentComparisonPhotos.removeAt(comparisonIndex);

      // Add old base photo to comparison photos if it exists
      if (state.basePhoto != null) {
        currentComparisonPhotos.add(state.basePhoto!);
      }

      state = state.copyWith(
        basePhoto: newBasePhoto,
        comparisonPhotos: currentComparisonPhotos,
      );
    }
  }

  int get trashCount => state.trashPhotos.length;
}

final photoProvider = StateNotifierProvider<PhotoNotifier, PhotoState>((ref) {
  return PhotoNotifier();
});
