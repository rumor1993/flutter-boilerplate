import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGalleryPicker extends StatefulWidget {
  final bool allowMultiple;
  final List<AssetEntity>? initialSelected;
  final Function(List<AssetEntity>) onSelectionChanged;
  final Function(List<AssetEntity>, String?)? onSelectionChangedWithAlbum;
  final String title;
  final String? startAfterAssetId;  // Start showing photos after this asset
  final String? preferredAlbumId;   // Preferred album to start from

  const PhotoGalleryPicker({
    super.key,
    this.allowMultiple = false,
    this.initialSelected,
    required this.onSelectionChanged,
    this.onSelectionChangedWithAlbum,
    this.title = 'Select Photos',
    this.startAfterAssetId,
    this.preferredAlbumId,
  });

  @override
  State<PhotoGalleryPicker> createState() => _PhotoGalleryPickerState();
}

class _PhotoGalleryPickerState extends State<PhotoGalleryPicker> {
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _assets = [];
  List<AssetEntity> _selectedAssets = [];
  AssetPathEntity? _selectedAlbum;
  bool _isLoading = true;
  int _currentPage = 0;
  bool _hasMore = true;
  final int _pageSize = 50;
  int _startAfterIndex = 0;  // Index to start loading from
  bool _foundStartPosition = false;

  @override
  void initState() {
    super.initState();
    _selectedAssets = List.from(widget.initialSelected ?? []);
    _requestPermissionAndLoadAlbums();
  }

  Future<void> _requestPermissionAndLoadAlbums() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      await _loadAlbums();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAlbums() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );
      
      if (albums.isNotEmpty) {
        // Find preferred album if specified
        AssetPathEntity? preferredAlbum;
        if (widget.preferredAlbumId != null) {
          preferredAlbum = albums.firstWhere(
            (album) => album.id == widget.preferredAlbumId,
            orElse: () => albums.first,
          );
        }
        
        setState(() {
          _albums = albums;
          _selectedAlbum = preferredAlbum ?? albums.first;
        });
        
        // Find start position if specified
        if (widget.startAfterAssetId != null) {
          await _findStartPosition();
        }
        
        await _loadAssets();
      }
    } catch (e) {
      print('Error loading albums: $e');
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _findStartPosition() async {
    if (_selectedAlbum == null || widget.startAfterAssetId == null) return;
    
    try {
      final totalCount = await _selectedAlbum!.assetCountAsync;
      int searchIndex = 0;
      
      // Search for the base photo position
      while (searchIndex < totalCount) {
        final searchBatch = await _selectedAlbum!.getAssetListPaged(
          page: searchIndex ~/ _pageSize,
          size: _pageSize,
        );
        
        final foundIndex = searchBatch.indexWhere(
          (asset) => asset.id == widget.startAfterAssetId,
        );
        
        if (foundIndex != -1) {
          // Found the base photo, start from the next photo
          _startAfterIndex = searchIndex + foundIndex + 1;
          _foundStartPosition = true;
          break;
        }
        
        searchIndex += searchBatch.length;
        if (searchBatch.length < _pageSize) break;
      }
    } catch (e) {
      print('Error finding start position: $e');
    }
  }

  Future<void> _loadAssets() async {
    if (_selectedAlbum == null) return;

    try {
      int actualPage = _currentPage;
      int actualStartIndex = _startAfterIndex;
      
      // If we found a start position, adjust the page calculation
      if (_foundStartPosition && _currentPage == 0) {
        actualPage = actualStartIndex ~/ _pageSize;
        actualStartIndex = actualStartIndex % _pageSize;
      }
      
      final assets = await _selectedAlbum!.getAssetListPaged(
        page: actualPage,
        size: _pageSize,
      );
      
      // If this is the first page and we have a start position, skip photos before it
      List<AssetEntity> filteredAssets = assets;
      if (_foundStartPosition && _currentPage == 0 && actualStartIndex > 0) {
        filteredAssets = assets.skip(actualStartIndex).toList();
      }
      
      setState(() {
        if (_currentPage == 0) {
          _assets = filteredAssets;
        } else {
          _assets.addAll(filteredAssets);
        }
        _hasMore = assets.length == _pageSize;
        _currentPage++;
      });
    } catch (e) {
      print('Error loading assets: $e');
    }
  }

  Future<void> _loadMoreAssets() async {
    if (_hasMore && !_isLoading) {
      await _loadAssets();
    }
  }

  void _selectAsset(AssetEntity asset) {
    setState(() {
      if (widget.allowMultiple) {
        if (_selectedAssets.contains(asset)) {
          _selectedAssets.remove(asset);
        } else {
          _selectedAssets.add(asset);
        }
      } else {
        _selectedAssets = [asset];
      }
    });
    widget.onSelectionChanged(_selectedAssets);
    widget.onSelectionChangedWithAlbum?.call(_selectedAssets, _selectedAlbum?.id);
  }

  void _changeAlbum(AssetPathEntity album) {
    setState(() {
      _selectedAlbum = album;
      _assets.clear();
      _currentPage = 0;
      _hasMore = true;
      _isLoading = true;
      _startAfterIndex = 0;
      _foundStartPosition = false;
    });
    
    // Find start position for new album if needed
    if (widget.startAfterAssetId != null) {
      _findStartPosition().then((_) {
        _loadAssets().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } else {
      _loadAssets().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          if (_selectedAssets.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'assets': _selectedAssets,
                  'albumId': _selectedAlbum?.id,
                });
              },
              child: Text(
                'Done${_selectedAssets.isNotEmpty ? ' (${_selectedAssets.length})' : ''}',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Album selector
                if (_albums.length > 1)
                  Container(
                    height: 50,
                    color: Colors.grey[900],
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _albums.length,
                      itemBuilder: (context, index) {
                        final album = _albums[index];
                        final isSelected = album == _selectedAlbum;
                        
                        return GestureDetector(
                          onTap: () => _changeAlbum(album),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                album.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[400],
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                
                // Photo grid
                Expanded(
                  child: _assets.isEmpty
                      ? const Center(
                          child: Text(
                            'No photos found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                              _loadMoreAssets();
                            }
                            return false;
                          },
                          child: GridView.builder(
                            padding: const EdgeInsets.all(4),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemCount: _assets.length,
                            itemBuilder: (context, index) {
                              final asset = _assets[index];
                              final isSelected = _selectedAssets.contains(asset);
                              
                              return GestureDetector(
                                onTap: () => _selectAsset(asset),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: isSelected
                                            ? Border.all(color: Colors.blue, width: 3)
                                            : null,
                                      ),
                                      child: FutureBuilder<Uint8List?>(
                                        future: asset.thumbnailDataWithSize(
                                          const ThumbnailSize(200, 200),
                                          quality: 70,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData && snapshot.data != null) {
                                            return Image.memory(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            );
                                          }
                                          return Container(
                                            color: Colors.grey[800],
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    if (widget.allowMultiple && isSelected)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${_selectedAssets.indexOf(asset) + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                ),
              ],
            ),
    );
  }
}