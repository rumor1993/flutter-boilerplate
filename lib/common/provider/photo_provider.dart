import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PhotoState {
  final dynamic basePhoto; // Can be File or XFile for web compatibility
  final List<dynamic> comparisonPhotos; // Can be List<File> or List<XFile>

  PhotoState({
    this.basePhoto,
    this.comparisonPhotos = const [],
  });

  PhotoState copyWith({
    dynamic basePhoto,
    List<dynamic>? comparisonPhotos,
  }) {
    return PhotoState(
      basePhoto: basePhoto ?? this.basePhoto,
      comparisonPhotos: comparisonPhotos ?? this.comparisonPhotos,
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

  void clearBasePhoto() {
    state = state.copyWith(basePhoto: null);
  }

  void clearComparisonPhotos() {
    state = state.copyWith(comparisonPhotos: []);
  }

  void clearAllPhotos() {
    state = PhotoState();
  }
}

final photoProvider = StateNotifierProvider<PhotoNotifier, PhotoState>((ref) {
  return PhotoNotifier();
});