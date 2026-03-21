import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/coffee_shop.dart';

class SpinWheelWidget extends StatefulWidget {
  const SpinWheelWidget({
    super.key,
    required this.shops,
    required this.spinRequestId,
    required this.targetIndex,
    required this.onSpinEnd,
  });

  final List<CoffeeShop> shops;
  final int spinRequestId;
  final int? targetIndex;
  final ValueChanged<int> onSpinEnd;

  @override
  State<SpinWheelWidget> createState() => _SpinWheelWidgetState();
}

class _SpinWheelWidgetState extends State<SpinWheelWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _lastSpinRequestId = 0;
  double _currentRotation = 0;
  double _spinStart = 0;
  double _spinEnd = 0;
  int _activeTargetIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastSpinRequestId = widget.spinRequestId;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3300),
    )..addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant SpinWheelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.spinRequestId != _lastSpinRequestId &&
        widget.targetIndex != null &&
        widget.shops.length >= 2) {
      _lastSpinRequestId = widget.spinRequestId;
      _startSpin(widget.targetIndex!);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onAnimationStatus)
      ..dispose();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _currentRotation = _spinEnd;
      widget.onSpinEnd(_activeTargetIndex);
    }
  }

  void _startSpin(int targetIndex) {
    final int count = widget.shops.length;
    final double sweep = (2 * pi) / count;

    _activeTargetIndex = targetIndex;
    _spinStart = _currentRotation;

    final double currentMod = _normalize(_currentRotation);
    final double targetMod = _normalize(-targetIndex * sweep);
    final double offset = _normalize(targetMod - currentMod);

    _spinEnd = _currentRotation + (2 * pi * 6) + offset;
    _controller
      ..reset()
      ..forward();
  }

  double _normalize(double value) {
    final double mod = value % (2 * pi);
    return mod < 0 ? mod + (2 * pi) : mod;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shops.length < 2) {
      return _WheelEmptyState();
    }

    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double eased = Curves.easeOutCubic.transform(_controller.value);
          final double rotation = lerpDouble(_spinStart, _spinEnd, eased) ?? 0;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: rotation,
                child: _WheelBody(shops: widget.shops),
              ),
              const Positioned(top: 0, child: _WheelPointer()),
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WheelPointer extends StatelessWidget {
  const _WheelPointer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 16),
      painter: _PointerTipPainter(),
    );
  }
}

class _PointerTipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path shadowPath = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(
      shadowPath.shift(const Offset(0, 1)),
      Paint()..color = AppColors.shadowSoft,
    );

    final Paint fill = Paint()..color = const Color(0xFFD89A54);
    canvas.drawPath(shadowPath, fill);
    canvas.drawPath(
      shadowPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9
        ..color = AppColors.secondary.withValues(alpha: 0.85),
    );

    final Path highlight = Path()
      ..moveTo(size.width / 2, size.height * 0.74)
      ..lineTo(size.width * 0.3, size.height * 0.12)
      ..lineTo(size.width * 0.7, size.height * 0.12)
      ..close();
    canvas.drawPath(
      highlight,
      Paint()..color = Colors.white.withValues(alpha: 0.28),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WheelBody extends StatelessWidget {
  const _WheelBody({required this.shops});

  final List<CoffeeShop> shops;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size(220, 220),
            painter: _WheelPainter(segmentCount: shops.length),
          ),
          ..._buildWheelLabels(shops),
        ],
      ),
    );
  }

  List<Widget> _buildWheelLabels(List<CoffeeShop> entries) {
    const double radius = 68;
    final double step = (2 * pi) / entries.length;

    return List<Widget>.generate(entries.length, (int index) {
      final double angle = (-pi / 2) + (step * index);
      final double dx = radius * cos(angle);
      final double dy = radius * sin(angle);
      final String text = entries[index].name;

      return Positioned(
        left: 110 + dx - 30,
        top: 110 + dy - 11,
        child: SizedBox(
          width: 60,
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    });
  }
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter({required this.segmentCount});

  final int segmentCount;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 8;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.background;

    final double sweep = (2 * pi) / segmentCount;
    double start = -pi / 2 - (sweep / 2);

    for (int i = 0; i < segmentCount; i++) {
      fillPaint.color = i.isEven ? AppColors.primary : const Color(0xFFFFA04A);
      canvas.drawArc(rect, start, sweep, true, fillPaint);
      canvas.drawArc(rect, start, sweep, true, borderPaint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) {
    return oldDelegate.segmentCount != segmentCount;
  }
}

class _WheelEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.casino_rounded, color: AppColors.primary, size: 30),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select at least 2 shops',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
