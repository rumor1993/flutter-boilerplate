import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoState {
  final dynamic basePhoto; // Can be File or XFile for web compatibility
  final List<dynamic> comparisonPhotos; // Can be List<File> or List<XFile>
  final List<dynamic> trashPhotos; // Photos moved to trash

  PhotoState({
    this.basePhoto,
    this.comparisonPhotos = const [],
    this.trashPhotos = const [],
  });

  PhotoState copyWith({
    dynamic basePhoto,
    List<dynamic>? comparisonPhotos,
    List<dynamic>? trashPhotos,
  }) {
    return PhotoState(
      basePhoto: basePhoto ?? this.basePhoto,
      comparisonPhotos: comparisonPhotos ?? this.comparisonPhotos,
      trashPhotos: trashPhotos ?? this.trashPhotos,
    );
  }
}

class PhotoNotifier extends StateNotifier<PhotoState> {
  PhotoNotifier() : super(PhotoState());

  final ImagePicker _picker = ImagePicker();

  Future<void> selectBasePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        state = state.copyWith(basePhoto: File(image.path));
      }
    } catch (e) {
      print('Error selecting base photo: $e');
    }
  }

  Future<void> addComparisonPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        final currentPhotos = List<File>.from(state.comparisonPhotos);
        currentPhotos.add(File(image.path));
        state = state.copyWith(comparisonPhotos: currentPhotos);
      }
    } catch (e) {
      print('Error adding comparison photo: $e');
    }
  }

  Future<void> addMultipleComparisonPhotos() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        final currentPhotos = List<File>.from(state.comparisonPhotos);
        for (final image in images) {
          currentPhotos.add(File(image.path));
        }
        state = state.copyWith(comparisonPhotos: currentPhotos);
      }
    } catch (e) {
      print('Error adding multiple comparison photos: $e');
    }
  }

  void removeComparisonPhoto(int index) {
    final currentPhotos = List<File>.from(state.comparisonPhotos);
    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      state = state.copyWith(comparisonPhotos: currentPhotos);
    }
  }

  void moveComparisonPhotoToTrash(int index) {
    final currentPhotos = List<File>.from(state.comparisonPhotos);
    final currentTrash = List<File>.from(state.trashPhotos);
    
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
    final currentPhotos = List<File>.from(state.comparisonPhotos);
    final currentTrash = List<File>.from(state.trashPhotos);
    
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
    final currentPhotos = List<File>.from(state.comparisonPhotos);
    final trashPhotos = List<File>.from(state.trashPhotos);
    
    currentPhotos.addAll(trashPhotos);
    
    state = state.copyWith(
      comparisonPhotos: currentPhotos,
      trashPhotos: [],
    );
  }

  void clearTrash() {
    state = state.copyWith(trashPhotos: []);
  }

  Future<void> deleteTrashPhotosPermanently() async {
    try {
      final trashPhotos = List<File>.from(state.trashPhotos);
      
      // Request permission to access photos
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps != PermissionState.authorized) {
        print('Permission denied for photo access');
        return;
      }
      
      for (final photo in trashPhotos) {
        try {
          // Try to delete from device gallery using photo_manager
          final AssetEntity? asset = await _findAssetByPath(photo.path);
          if (asset != null) {
            final List<String> result = await PhotoManager.editor.deleteWithIds([asset.id]);
            if (result.isNotEmpty) {
              print('Successfully deleted ${photo.path} from gallery');
            }
          }
          
          // Also delete the file if it still exists
          if (await photo.exists()) {
            await photo.delete();
          }
        } catch (e) {
          print('Error deleting photo ${photo.path}: $e');
          // Continue with next photo even if one fails
        }
      }
      
      // Clear trash after deletion attempts
      state = state.copyWith(trashPhotos: []);
    } catch (e) {
      print('Error deleting trash photos permanently: $e');
    }
  }

  Future<AssetEntity?> _findAssetByPath(String path) async {
    try {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      
      for (final album in albums) {
        final List<AssetEntity> assets = await album.getAssetListRange(
          start: 0,
          end: await album.assetCountAsync,
        );
        
        for (final asset in assets) {
          final File? file = await asset.file;
          if (file != null && file.path == path) {
            return asset;
          }
        }
      }
      return null;
    } catch (e) {
      print('Error finding asset by path: $e');
      return null;
    }
  }

  Future<void> deleteSpecificTrashPhoto(int trashIndex) async {
    try {
      final currentTrash = List<File>.from(state.trashPhotos);
      
      if (trashIndex >= 0 && trashIndex < currentTrash.length) {
        final photoToDelete = currentTrash[trashIndex];
        
        // Request permission to access photos
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps == PermissionState.authorized) {
          // Try to delete from device gallery using photo_manager
          final AssetEntity? asset = await _findAssetByPath(photoToDelete.path);
          if (asset != null) {
            final List<String> result = await PhotoManager.editor.deleteWithIds([asset.id]);
            if (result.isNotEmpty) {
              print('Successfully deleted ${photoToDelete.path} from gallery');
            }
          }
        }
        
        // Also delete the file if it still exists
        if (await photoToDelete.exists()) {
          await photoToDelete.delete();
        }
        
        currentTrash.removeAt(trashIndex);
        state = state.copyWith(trashPhotos: currentTrash);
      }
    } catch (e) {
      print('Error deleting specific trash photo: $e');
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
    final currentTrash = List<File>.from(state.trashPhotos);
    
    // Add base photo to trash if it exists
    if (state.basePhoto != null) {
      currentTrash.add(state.basePhoto as File);
    }
    
    // Add all comparison photos to trash
    currentTrash.addAll(state.comparisonPhotos.cast<File>());
    
    // Clear all photos and update trash
    state = PhotoState(trashPhotos: currentTrash);
  }

  void changeBasePhoto(int comparisonIndex) {
    final currentComparisonPhotos = List<File>.from(state.comparisonPhotos);
    
    if (comparisonIndex >= 0 && comparisonIndex < currentComparisonPhotos.length) {
      final newBasePhoto = currentComparisonPhotos[comparisonIndex];
      currentComparisonPhotos.removeAt(comparisonIndex);
      
      // Add old base photo to comparison photos if it exists
      if (state.basePhoto != null) {
        currentComparisonPhotos.add(state.basePhoto as File);
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