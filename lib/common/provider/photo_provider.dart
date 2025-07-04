import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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

  void clearTrash() {
    state = state.copyWith(trashPhotos: []);
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