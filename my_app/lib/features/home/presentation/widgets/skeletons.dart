import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 9),
    this.baseColor = const Color(0xFFE9EDF3),
    this.highlightColor = const Color(0xFFF6F8FB),
    this.enabled = true,
  });

  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;
  final bool enabled;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _ctl
        ..duration = widget.duration
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _ctl,
      builder: (_, __) {
        // Giá trị 0..1; dịch chuyển gradient ngang toàn bộ bề mặt
        final v = _ctl.value;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect rect) {
            // Gradient đi từ trái -> phải, có dải sáng ở giữa
            final begin = Alignment(-1.5 + (3.0 * v), 0.0);
            final end = Alignment(1.5 + (3.0 * v), 0.0);

            return LinearGradient(
              begin: begin,
              end: end,
              colors: <Color>[
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const <double>[0.25, 0.5, 0.75],
            ).createShader(rect);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Khối placeholder chung (hộp bo góc).
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.color = const Color(0xFFE9EDF3),
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Dòng placeholder (thanh dài).
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    required this.width,
    this.height = 12,
    this.radius = 8,
    this.color = const Color(0xFFE9EDF3),
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height, borderRadius: radius, color: color);
  }
}

/// Một chip skeleton.
class SkeletonChip extends StatelessWidget {
  const SkeletonChip({super.key, this.width = 72, this.height = 28});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: SkeletonBox(width: width, height: height, borderRadius: 999),
    );
  }
}

/// Hàng chip skeleton (dùng khi đang tải quận/huyện).
class SkeletonChipRow extends StatelessWidget {
  const SkeletonChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final w = 56 + (i % 4) * 18; // chip có độ rộng khác nhau cho tự nhiên
          return SkeletonChip(width: w.toDouble(), height: 28);
        },
      ),
    );
  }
}

/// Card skeleton mô phỏng layout HotelCard.
class SkeletonHotelCard extends StatelessWidget {
  const SkeletonHotelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const SkeletonBox(width: 120, height: 90),
            ),
            const SizedBox(width: 12),

            // Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  SkeletonLine(width: 180, height: 16),
                  SizedBox(height: 8),
                  SkeletonLine(width: 220, height: 12),
                  SizedBox(height: 6),
                  SkeletonLine(width: 140, height: 12),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      // badge rating
                      SkeletonBox(width: 64, height: 24, borderRadius: 999),
                      Spacer(),
                      SkeletonLine(width: 110, height: 14),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
