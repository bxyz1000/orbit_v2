import 'package:flutter/material.dart';
import '../../domain/analytics_point.dart';
import '../../../../core/theme/orbit_spacing.dart';
import '../../../../shared/widgets/orbit_group_card.dart';

class ScoreTrendChart extends StatefulWidget {
  final List<AnalyticsPoint<int>> points;

  const ScoreTrendChart({
    super.key,
    required this.points,
  });

  @override
  State<ScoreTrendChart> createState() => _ScoreTrendChartState();
}

class _ScoreTrendChartState extends State<ScoreTrendChart> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) {
      return const OrbitGroupCard(
        padding: EdgeInsets.all(OrbitSpacing.xl),
        children: [
          Text('SCORE TREND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
          SizedBox(height: 48),
          Center(child: Text('No data yet', style: TextStyle(color: Colors.grey))),
          SizedBox(height: 48),
        ],
      );
    }

    final primaryColor = Theme.of(context).colorScheme.primary;

    return OrbitGroupCard(
      padding: const EdgeInsets.all(OrbitSpacing.xl),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SCORE TREND',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            if (_hoveredIndex != null && _hoveredIndex! < widget.points.length)
              Text(
                '${_formatDate(widget.points[_hoveredIndex!].date)}: ${widget.points[_hoveredIndex!].value}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
          ],
        ),
        OrbitSpacing.gapLg,
        SizedBox(
          height: 180,
          child: GestureDetector(
            onPanUpdate: (details) => _handleTouch(details.localPosition),
            onTapDown: (details) => _handleTouch(details.localPosition),
            onPanEnd: (_) => setState(() => _hoveredIndex = null),
            onTapUp: (_) => setState(() => _hoveredIndex = null),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: _TrendPainter(
                    points: widget.points,
                    animationValue: value,
                    color: primaryColor,
                    hoveredIndex: _hoveredIndex,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _handleTouch(Offset localPosition) {
    final width = context.size?.width ?? 0;
    // Account for padding in OrbitGroupCard (OrbitSpacing.xl = 24)
    const padding = 24.0; 
    final effectiveWidth = width - (padding * 2);
    
    if (widget.points.length > 1) {
      final stepX = effectiveWidth / (widget.points.length - 1);
      final index = ((localPosition.dx - padding) / stepX).round().clamp(0, widget.points.length - 1);
      if (index != _hoveredIndex) {
        setState(() {
          _hoveredIndex = index;
        });
      }
    } else if (widget.points.length == 1) {
      setState(() {
        _hoveredIndex = 0;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

class _TrendPainter extends CustomPainter {
  final List<AnalyticsPoint<int>> points;
  final double animationValue;
  final Color color;
  final int? hoveredIndex;

  _TrendPainter({
    required this.points,
    required this.animationValue,
    required this.color,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    final width = size.width;
    final height = size.height;
    final stepX = points.length > 1 ? width / (points.length - 1) : width;
    
    final maxValue = points.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b);
    final normalizedMax = maxValue < 100 ? 100.0 : maxValue + 20;

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = height - (points[i].value / normalizedMax * height * animationValue);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == points.length - 1) {
        fillPath.lineTo(x, height);
        fillPath.close();
      }
    }

    if (points.length > 1) {
      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, paint);
    }

    // Draw points or hover indicator
    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = height - (points[i].value / normalizedMax * height * animationValue);
      
      if (i == hoveredIndex) {
        canvas.drawCircle(Offset(x, y), 6, Paint()..color = color);
        canvas.drawCircle(Offset(x, y), 8, Paint()..color = color.withValues(alpha: 0.3));
        
        // Draw vertical line
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, height),
          Paint()..color = color.withValues(alpha: 0.1)..strokeWidth = 1,
        );
      } else if (points.length < 15) {
        // Only draw dots if not too many points
        canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
      }
    }
    
    if (points.length == 1) {
      final y = height - (points[0].value / normalizedMax * height * animationValue);
      canvas.drawCircle(Offset(width / 2, y), 6, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => 
      oldDelegate.animationValue != animationValue || oldDelegate.hoveredIndex != hoveredIndex;
}
