import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class CircularProgress3D extends StatefulWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Widget? child;
  final Duration animationDuration;
  final bool showGlow;

  const CircularProgress3D({
    super.key,
    required this.value,
    this.size = 200,
    this.strokeWidth = 20,
    required this.gradientColors,
    this.child,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.showGlow = true,
  });

  @override
  State<CircularProgress3D> createState() => _CircularProgress3DState();
}

class _CircularProgress3DState extends State<CircularProgress3D>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _rotationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(_rotationController);

    _progressController.forward();
  }

  @override
  void didUpdateWidget(CircularProgress3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CircularProgress3DPainter(
            progress: _progressAnimation.value,
            rotation: 0,
            strokeWidth: widget.strokeWidth,
            gradientColors: widget.gradientColors,
            showGlow: widget.showGlow,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}

class _CircularProgress3DPainter extends CustomPainter {
  final double progress;
  final double rotation;
  final double strokeWidth;
  final List<Color> gradientColors;
  final bool showGlow;

  _CircularProgress3DPainter({
    required this.progress,
    required this.rotation,
    required this.strokeWidth,
    required this.gradientColors,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background circle with 3D effect
    _drawBackgroundCircle(canvas, center, radius);

    // Draw progress arc with gradient and glow
    _drawProgressArc(canvas, center, radius, rect);

    // Draw highlight for 3D effect
    _drawHighlight(canvas, center, radius);
  }

  void _drawBackgroundCircle(Canvas canvas, Offset center, double radius) {
    // Shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      center.translate(4, 4),
      radius,
      shadowPaint,
    );

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
  }

  void _drawProgressArc(Canvas canvas, Offset center, double radius, Rect rect) {
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    // Glow effect
    if (showGlow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      glowPaint.shader = ui.Gradient.sweep(
        center,
        gradientColors.map((c) => c.withOpacity(0.3)).toList(),
        null,
        TileMode.clamp,
        -math.pi / 2,
        -math.pi / 2 + sweepAngle,
      );

      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    // Main progress arc with gradient
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    progressPaint.shader = ui.Gradient.sweep(
      center,
      gradientColors,
      null,
      TileMode.clamp,
      -math.pi / 2,
      -math.pi / 2 + sweepAngle,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  void _drawHighlight(Canvas canvas, Offset center, double radius) {
    // Top highlight for 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final highlightRect = Rect.fromCircle(
      center: center.translate(0, -2),
      radius: radius,
    );

    canvas.drawArc(
      highlightRect,
      -math.pi,
      math.pi,
      false,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgress3DPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.rotation != rotation;
  }
}
