import 'package:flutter/material.dart';

class DeleteDropZone extends StatefulWidget {
  final Function(String layerId) onDelete;
  final bool isVisible;

  const DeleteDropZone({
    super.key,
    required this.onDelete,
    required this.isVisible,
  });

  @override
  State<DeleteDropZone> createState() => _DeleteDropZoneState();
}

class _DeleteDropZoneState extends State<DeleteDropZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHighlighted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: DragTarget<String>(
          onAcceptWithDetails: (details) {
            widget.onDelete(details.data);
            setState(() => _isHighlighted = false);
            _controller.reverse();
          },
          onWillAcceptWithDetails: (details) {
            setState(() => _isHighlighted = true);
            _controller.forward();
            return true;
          },
          onLeave: (data) {
            setState(() => _isHighlighted = false);
            _controller.reverse();
          },
          builder: (context, candidateData, rejectedData) {
            return AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isHighlighted 
                          ? Colors.red.withOpacity(0.8)
                          : Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isHighlighted ? Colors.red : Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: _isHighlighted ? 40 : 35,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}