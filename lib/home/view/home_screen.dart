import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _mealHistory = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _seconds = 0;
    });
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _animationController.reverse();
    _pulseController.stop();
    
    setState(() {
      _isRunning = false;
    });

    final now = DateTime.now();
    _mealHistory.insert(0, {
      'duration': _seconds,
      'time': now,
      'mealType': _getMealType(now),
    });

    _showMealCompleteDialog();
  }

  String _getMealType(DateTime time) {
    final hour = time.hour;
    if (hour >= 6 && hour < 11) return '아침';
    if (hour >= 11 && hour < 15) return '점심';
    if (hour >= 15 && hour < 18) return '간식';
    return '저녁';
  }

  void _showMealCompleteDialog() {
    final duration = _formatDuration(_seconds);
    final speed = _getMealSpeed(_seconds);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getSpeedColor(speed).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: _getSpeedColor(speed),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '식사 완료!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.9),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getSpeedColor(speed).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  speed,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getSpeedColor(speed),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withValues(alpha: 0.7),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getSpeedAdvice(speed),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getSpeedColor(speed),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMealSpeed(int seconds) {
    if (seconds < 300) return '매우 빠름';
    if (seconds < 600) return '빠름';
    if (seconds < 1200) return '적당함';
    if (seconds < 1800) return '느림';
    return '매우 느림';
  }

  String _getSpeedAdvice(String speed) {
    switch (speed) {
      case '매우 빠름':
        return '너무 빠르게 드셨어요.\n천천히 드시는 것이 소화에 좋습니다.';
      case '빠름':
        return '조금 빠르네요.\n좀 더 여유롭게 드셔보세요.';
      case '적당함':
        return '완벽한 속도입니다!\n건강한 식사 습관을 유지하고 계시네요.';
      case '느림':
        return '천천히 드셨네요.\n음식의 맛을 충분히 즐기셨을 것 같아요.';
      default:
        return '여유롭게 드셨어요.\n마음의 평화와 함께 식사하셨네요.';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}분 ${remainingSeconds}초';
    }
    return '${remainingSeconds}초';
  }

  Color _getSpeedColor(String speed) {
    switch (speed) {
      case '매우 빠름':
        return const Color(0xFFFF5757);
      case '빠름':
        return const Color(0xFF4ECDC4);
      case '적당함':
        return const Color(0xFF4CAF50);
      case '느림':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFFAFBFC),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                '식사 타이머',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withValues(alpha: 0.9),
                  letterSpacing: -1,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: Colors.black.withValues(alpha: 0.7),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _buildTimerSection(),
                const SizedBox(height: 40),
                _buildTodayStats(),
                const SizedBox(height: 32),
                _buildRecentMeals(),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _isRunning ? '식사 중입니다' : '식사를 시작해보세요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.8),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRunning ? _pulseAnimation.value : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CircularTimerPainter(
                              progress: _isRunning ? 1.0 : 0.0,
                              color: const Color(0xFF4ECDC4),
                              strokeWidth: 6.0,
                              isRunning: _isRunning,
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: _isRunning ? _stopTimer : _startTimer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: _isRunning
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFFF5757).withValues(alpha: 0.1),
                                    const Color(0xFFFF5757).withValues(alpha: 0.05),
                                  ],
                                )
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                                    const Color(0xFF4ECDC4).withValues(alpha: 0.05),
                                  ],
                                ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isRunning 
                                ? const Color(0xFFFF5757).withValues(alpha: 0.3)
                                : const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isRunning ? const Color(0xFFFF5757) : const Color(0xFF4ECDC4))
                                  .withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                              size: 48,
                              color: _isRunning 
                                  ? const Color(0xFFFF5757)
                                  : const Color(0xFF4ECDC4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isRunning ? _formatDuration(_seconds) : '시작',
                              style: TextStyle(
                                fontSize: _isRunning ? 20 : 22,
                                fontWeight: FontWeight.w700,
                                color: _isRunning 
                                    ? const Color(0xFFFF5757)
                                    : const Color(0xFF4ECDC4),
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            _isRunning ? '식사를 마치면 터치하세요' : '시작 버튼을 눌러보세요',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats() {
    final today = DateTime.now();
    final todayMeals = _mealHistory.where((meal) {
      final mealDate = meal['time'] as DateTime;
      return mealDate.day == today.day &&
          mealDate.month == today.month &&
          mealDate.year == today.year;
    }).toList();

    final totalTime = todayMeals.fold<int>(0, (sum, meal) => sum + (meal['duration'] as int));
    final avgTime = todayMeals.isNotEmpty ? totalTime ~/ todayMeals.length : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4ECDC4).withValues(alpha: 0.08),
            const Color(0xFF4ECDC4).withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.today_rounded,
                  color: const Color(0xFF4ECDC4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '오늘의 식사',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.9),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('총 식사 횟수', '${todayMeals.length}회', Icons.restaurant_rounded),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('평균 시간', _formatDuration(avgTime), Icons.schedule_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF4ECDC4),
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black.withValues(alpha: 0.9),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            '최근 식사 기록',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black.withValues(alpha: 0.9),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _mealHistory.isEmpty
            ? Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.03),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: Colors.black.withValues(alpha: 0.3),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '아직 식사 기록이 없어요',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '첫 식사를 기록해보세요!',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: _mealHistory.take(5).map((meal) {
                  final duration = meal['duration'] as int;
                  final time = meal['time'] as DateTime;
                  final mealType = meal['mealType'] as String;
                  final speed = _getMealSpeed(duration);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _getSpeedColor(speed).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: _getSpeedColor(speed),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    mealType,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getSpeedColor(speed).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      speed,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _getSpeedColor(speed),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${_formatDuration(duration)} • ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}

class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool isRunning;

  CircularTimerPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.isRunning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress circle
    if (isRunning) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.6),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}