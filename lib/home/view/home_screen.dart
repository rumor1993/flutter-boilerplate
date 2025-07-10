import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/common/service/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:photo_app/generated/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _basePhotoKey = GlobalKey();
  final GlobalKey _actionButtonKey = GlobalKey();
  bool _isNavigating = false;
  
  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }
  
  Future<void> _checkAndShowTutorial() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await TutorialService.isFirstTimeUser()) {
        await Future.delayed(const Duration(milliseconds: 500));
        _showTutorial();
      }
    });
  }
  
  void _showTutorial() {
    final targets = [
      TargetFocus(
        identify: "basePhoto",
        keyTarget: _basePhotoKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.getStarted,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.selectPhotosDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          print("Next button tapped");
                          controller.next();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.next,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];
    
    TutorialService.showTutorial(
      context: context,
      targets: targets,
      onFinish: () {
        TutorialService.setFirstTimeComplete();
      },
      onSkip: () {
        TutorialService.setFirstTimeComplete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoState = ref.watch(photoProvider);
    
    // Set context for photo provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(photoProvider.notifier).setContext(context);
    });
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: Colors.grey[800],
                    onSelected: (String value) {
                      switch (value) {
                        case 'tutorial':
                          _showTutorial();
                          break;
                        case 'reset':
                          TutorialService.resetAllTutorials().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.tutorialsResetMessage),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'tutorial',
                        child: Row(
                          children: [
                            const Icon(Icons.help_outline, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.showTutorial, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'reset',
                        child: Row(
                          children: [
                            const Icon(Icons.refresh, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.resetAllTutorials, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                AppLocalizations.of(context)!.appSubtitle,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Photo Preview Section
              Row(
                children: [
                  // Single photo card
                  Expanded(
                    key: _basePhotoKey,
                    child: GestureDetector(
                      onTap: () async {
                        if (_isNavigating) return;
                        
                        if (photoState.basePhoto == null) {
                          // Select multiple photos from home - PhotoGalleryPicker will handle navigation
                          await ref.read(photoProvider.notifier).selectMultiplePhotosFromHome();
                        } else {
                          // Navigate to comparison screen if base photo is already selected
                          if (mounted) {
                            setState(() {
                              _isNavigating = true;
                            });
                            
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhotoComparisonScreen(),
                              ),
                            );
                            
                            if (mounted) {
                              setState(() {
                                _isNavigating = false;
                              });
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: photoState.basePhoto != null
                              ? photoState.basePhoto!.buildImage(
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  useThumbnail: true,
                                  thumbnailSize: const ThumbnailSize(400, 400),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_photo_alternate,
                                          size: 40,
                                          color: Colors.white70,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppLocalizations.of(context)!.photosPreview,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Split view card
                  Expanded(
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFE2A54A),
                                      Color(0xFFBD8D35),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.beach_access,
                                    size: 40,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 1, color: Colors.black26),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4AE2A5),
                                      Color(0xFF35BD8A),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.wb_sunny,
                                    size: 40,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Action Button
              SizedBox(
                key: _actionButtonKey,
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isNavigating) return;
                    
                    if (photoState.basePhoto == null) {
                      // Select multiple photos from home - PhotoGalleryPicker will handle navigation
                      await ref.read(photoProvider.notifier).selectMultiplePhotosFromHome();
                    } else {
                      // Navigate to comparison screen if base photo is already selected
                      if (mounted) {
                        setState(() {
                          _isNavigating = true;
                        });
                        
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotoComparisonScreen(),
                          ),
                        );
                        
                        if (mounted) {
                          setState(() {
                            _isNavigating = false;
                          });
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.photo_library, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        photoState.basePhoto == null ? AppLocalizations.of(context)!.selectPhotos : AppLocalizations.of(context)!.startComparing,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

                  const Spacer(),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (_isNavigating)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.loading,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
