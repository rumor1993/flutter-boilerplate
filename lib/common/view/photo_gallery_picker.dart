import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoGalleryPicker extends StatefulWidget {
  final bool allowMultiple;
  final List<AssetEntity>? initialSelected;
  final Function(List<AssetEntity>) onSelectionChanged;
  final String title;
  final String? disabledAssetId; // Asset ID to disable (usually base photo)
  final String? centerAroundAssetId; // Asset ID to center the view around

  const PhotoGalleryPicker({
    super.key,
    this.allowMultiple = false,
    this.initialSelected,
    required this.onSelectionChanged,
    this.title = 'Select Photos',
    this.disabledAssetId,
    this.centerAroundAssetId,
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
  bool _isLoadingMore = false;
  int _currentPage = 0;
  bool _hasMore = true;
  final int _pageSize = 50;
  int? _basePhotoIndex; // Index of the base photo in the album
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;
  bool _isProcessing = false; // Add processing state
  
  // Cache thumbnails to prevent flickering
  final Map<String, Uint8List?> _thumbnailCache = {};

  @override
  void initState() {
    super.initState();
    _selectedAssets = List.from(widget.initialSelected ?? []);
    _requestPermissionAndLoadAlbums();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        setState(() {
          _albums = albums;
          _selectedAlbum = albums.first; // Always start with "All Photos"
        });
        
        // Find base photo position if specified
        if (widget.centerAroundAssetId != null) {
          await _findBasePhotoPosition();
        }
        
        await _loadAssetsAroundBasePhoto();
      }
    } catch (e) {
      print('Error loading albums: $e');
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _findBasePhotoPosition() async {
    if (_selectedAlbum == null || widget.centerAroundAssetId == null) return;

    try {
      final totalCount = await _selectedAlbum!.assetCountAsync;
      int searchIndex = 0;
      
      // Search through all photos to find the base photo
      while (searchIndex < totalCount) {
        final searchBatch = await _selectedAlbum!.getAssetListPaged(
          page: searchIndex ~/ _pageSize,
          size: _pageSize,
        );
        
        final foundIndex = searchBatch.indexWhere(
          (asset) => asset.id == widget.centerAroundAssetId,
        );
        
        if (foundIndex != -1) {
          _basePhotoIndex = searchIndex + foundIndex;
          break;
        }
        
        searchIndex += searchBatch.length;
        if (searchBatch.length < _pageSize) break;
      }
    } catch (e) {
      print('Error finding base photo position: $e');
    }
  }

  Future<void> _loadAssetsAroundBasePhoto() async {
    if (_selectedAlbum == null) return;

    try {
      List<AssetEntity> allAssets = [];
      
      if (_basePhotoIndex != null) {
        // Load initial batch around the base photo position
        final startIndex = (_basePhotoIndex! - 25).clamp(0, double.infinity).toInt();
        final endIndex = _basePhotoIndex! + 25;
        
        // Load in chunks around the base photo
        for (int i = startIndex; i <= endIndex; i += _pageSize) {
          final page = i ~/ _pageSize;
          final assets = await _selectedAlbum!.getAssetListPaged(
            page: page,
            size: _pageSize,
          );
          allAssets.addAll(assets);
          
          if (assets.length < _pageSize) break;
        }
      } else {
        // Fallback to normal loading
        final assets = await _selectedAlbum!.getAssetListPaged(
          page: 0,
          size: _pageSize,
        );
        allAssets = assets;
      }
      
      setState(() {
        _assets = allAssets;
        _hasMore = allAssets.length >= _pageSize; // Re-enable infinite scroll
        _currentPage = _basePhotoIndex != null ? (_basePhotoIndex! ~/ _pageSize) + 1 : 1;
      });
      
      // Scroll to base photo position after loading
      if (_basePhotoIndex != null && !_initialScrollDone) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBasePhoto();
        });
      }
    } catch (e) {
      print('Error loading assets around base photo: $e');
      // Show error state
      setState(() {
        _assets = [];
        _hasMore = false;
      });
    }
  }

  void _scrollToBasePhoto() {
    if (_basePhotoIndex == null || _assets.isEmpty) return;
    
    // Find the base photo in the loaded assets
    final basePhotoInLoaded = _assets.indexWhere(
      (asset) => asset.id == widget.centerAroundAssetId,
    );
    
    if (basePhotoInLoaded != -1) {
      final itemHeight = MediaQuery.of(context).size.width / 3; // Grid item height
      final scrollOffset = (basePhotoInLoaded ~/ 3) * itemHeight;
      
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _initialScrollDone = true;
    }
  }

  Future<void> _loadAssets() async {
    if (_selectedAlbum == null) return;

    try {
      final assets = await _selectedAlbum!.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );
      
      setState(() {
        if (_currentPage == 0) {
          _assets = assets;
        } else {
          _assets.addAll(assets);
        }
        _hasMore = assets.length == _pageSize;
        _currentPage++;
      });
    } catch (e) {
      print('Error loading assets: $e');
    }
  }

  Future<void> _loadMoreAssets() async {
    if (_hasMore && !_isLoading && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      
      await _loadAssets();
      
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _selectAsset(AssetEntity asset) {
    // Don't allow selection if this asset is disabled
    if (widget.disabledAssetId != null && asset.id == widget.disabledAssetId) {
      return;
    }
    
    setState(() {
      if (widget.allowMultiple) {
        if (_selectedAssets.contains(asset)) {
          _selectedAssets.remove(asset);
        } else {
          // Check if we've reached the limit of 30 photos
          if (_selectedAssets.length < 30) {
            _selectedAssets.add(asset);
          } else {
            // Show a message or handle the limit
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Maximum 30 photos can be selected'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.orange,
              ),
            );
            return; // Don't add the asset
          }
        }
      } else {
        _selectedAssets = [asset];
      }
    });
    widget.onSelectionChanged(_selectedAssets);
  }

  Future<void> _handleDonePressed() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Small delay to show loading state
      await Future.delayed(const Duration(milliseconds: 300));

      // Return the result
      if (mounted) {
        Navigator.pop(context, {
          'assets': _selectedAssets,
          'albumId': _selectedAlbum?.id,
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing photos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _changeAlbum(AssetPathEntity album) {
    setState(() {
      _selectedAlbum = album;
      _assets.clear();
      _currentPage = 0;
      _hasMore = true;
      _isLoading = true;
      _basePhotoIndex = null;
      _initialScrollDone = false;
    });
    
    // Find base photo position in new album and load assets around it
    if (widget.centerAroundAssetId != null) {
      _findBasePhotoPosition().then((_) {
        _loadAssetsAroundBasePhoto().then((_) {
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
              onPressed: _isProcessing ? null : _handleDonePressed,
              child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  )
                : Text(
                    widget.allowMultiple 
                      ? 'Done (${_selectedAssets.length}/30)'
                      : 'Done${_selectedAssets.isNotEmpty ? ' (${_selectedAssets.length})' : ''}',
                    style: const TextStyle(color: Colors.blue),
                  ),
            ),
        ],
      ),
      body: _isLoading
          ? Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading photos...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Finding photos around your base image',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
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
                
                // Photo count and info
                if (_assets.isNotEmpty && widget.allowMultiple)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.grey[900],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.centerAroundAssetId != null 
                            ? 'Photos around your base image'
                            : 'Select photos',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _selectedAssets.length >= 30 
                              ? Colors.red.withValues(alpha: 0.2)
                              : Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_selectedAssets.length}/30 selected',
                            style: TextStyle(
                              color: _selectedAssets.length >= 30 ? Colors.red : Colors.blue, 
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
                          child: Stack(
                            children: [
                              GridView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(4),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: _assets.length,
                                itemBuilder: (context, index) {
                                  final asset = _assets[index];
                                  return PhotoGridItem(
                                    key: ValueKey(asset.id),
                                    asset: asset,
                                    isSelected: _selectedAssets.contains(asset),
                                    isDisabled: widget.disabledAssetId != null && asset.id == widget.disabledAssetId,
                                    allowMultiple: widget.allowMultiple,
                                    selectionIndex: _selectedAssets.indexOf(asset) + 1,
                                    onTap: () => _selectAsset(asset),
                                    thumbnailCache: _thumbnailCache,
                                  );
                                },
                              ),
                              
                              // Loading more indicator at bottom
                              if (_isLoadingMore)
                                Positioned(
                                  bottom: 20,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    margin: const EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Loading more...',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                              // Processing overlay
                              if (_isProcessing)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            strokeWidth: 4,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Preparing photos...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class PhotoGridItem extends StatefulWidget {
  final AssetEntity asset;
  final bool isSelected;
  final bool isDisabled;
  final bool allowMultiple;
  final int selectionIndex;
  final VoidCallback onTap;
  final Map<String, Uint8List?> thumbnailCache;

  const PhotoGridItem({
    super.key,
    required this.asset,
    required this.isSelected,
    required this.isDisabled,
    required this.allowMultiple,
    required this.selectionIndex,
    required this.onTap,
    required this.thumbnailCache,
  });

  @override
  State<PhotoGridItem> createState() => _PhotoGridItemState();
}

class _PhotoGridItemState extends State<PhotoGridItem> {
  Uint8List? _cachedThumbnail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    // Check cache first
    if (widget.thumbnailCache.containsKey(widget.asset.id)) {
      setState(() {
        _cachedThumbnail = widget.thumbnailCache[widget.asset.id];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final thumbnail = await widget.asset.thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
        quality: 70,
      );
      
      // Cache the thumbnail
      widget.thumbnailCache[widget.asset.id] = thumbnail;
      
      if (mounted) {
        setState(() {
          _cachedThumbnail = thumbnail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: widget.isSelected
                  ? Border.all(color: Colors.blue, width: 3)
                  : widget.isDisabled
                      ? Border.all(color: Colors.red, width: 2)
                      : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _cachedThumbnail != null
                      ? ColorFiltered(
                          colorFilter: widget.isDisabled
                              ? ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                )
                              : const ColorFilter.mode(
                                  Colors.transparent,
                                  BlendMode.multiply,
                                ),
                          child: Image.memory(
                            _cachedThumbnail!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                    size: 32,
                                  ),
                                ),
                        ),
                ),
                if (widget.isDisabled)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.block,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.isSelected && !widget.isDisabled)
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
                child: widget.allowMultiple
                    ? Center(
                        child: Text(
                          '${widget.selectionIndex}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
              ),
            ),
          if (widget.isDisabled)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BASE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

