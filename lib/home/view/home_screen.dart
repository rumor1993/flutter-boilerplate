import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_app/photo_comparison/view/photo_comparison_screen.dart';
import 'package:photo_app/common/provider/photo_provider.dart';
import 'package:photo_app/common/service/tutorial_service.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _basePhotoKey = GlobalKey();
  final GlobalKey _actionButtonKey = GlobalKey();
  
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Base Photo Preview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your selected base photo will appear here. This is your reference image for comparison.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "actionButton",
        keyTarget: _actionButtonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap here to select your base photo and start comparing photos. You can select up to 30 photos at once!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer for centering
                  const Expanded(
                    child: Text(
                      'Sort Your Photos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    color: Colors.grey[800],
                    onSelected: (String value) {
                      switch (value) {
                        case 'tutorial':
                          _showTutorial();
                          break;
                        case 'reset':
                          TutorialService.resetAllTutorials().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tutorials reset. Restart app to see them again.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          });
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'tutorial',
                        child: Row(
                          children: [
                            Icon(Icons.help_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Show Tutorial', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'reset',
                        child: Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Reset Tutorials', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Effortlessly organize your photo library\nwith smart sorting.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Photo Preview Section
              Row(
                children: [
                  // Single photo card
                  Expanded(
                    key: _basePhotoKey,
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
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Base Photo',
                                        style: TextStyle(
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
                    if (photoState.basePhoto == null) {
                      // Select base photo first
                      await ref.read(photoProvider.notifier).selectBasePhoto();
                      
                      // Check if photo was selected, then navigate to comparison screen
                      final updatedState = ref.read(photoProvider);
                      if (updatedState.basePhoto != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotoComparisonScreen(),
                          ),
                        );
                      }
                    } else {
                      // Navigate to comparison screen if base photo is already selected
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhotoComparisonScreen(),
                        ),
                      );
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
                        photoState.basePhoto == null ? 'Select Base Photo' : 'Choose Photos to Compare',
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
    );
  }
}
