import 'package:flutter/material.dart';

class AttractionListSkeleton extends StatelessWidget {
  const AttractionListSkeleton({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: count,
      itemBuilder: (_, __) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<Alignment> _shift;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shift = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(parent: _ctl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          _shimmerBox(width: 120, height: 90, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                _shimmerBox(height: 16),
                const SizedBox(height: 8),
                _shimmerBox(height: 12),
                const SizedBox(height: 6),
                _shimmerBox(height: 12),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _shimmerBox(width: 70, height: 20, radius: 999),
                    const Spacer(),
                    _shimmerBox(width: 110, height: 14),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _shimmerBox({double? width, double? height, double radius = 8}) {
    return AnimatedBuilder(
      animation: _shift,
      builder: (_, __) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFEDEDED),
                Color(0xFFDCDCDC),
                Color(0xFFEDEDED),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: _shift.value,
              end: Alignment(-_shift.value.x, _shift.value.y),
            ),
          ),
        );
      },
    );
  }
}
