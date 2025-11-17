import 'package:flutter/material.dart';
import 'dart:math' as math;

class CategoryRevenue extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoryRevenue({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _emptyCategoryWidget();
    }

    final totalRevenue = categories.fold(
      0.0,
          (sum, cat) => sum + (cat['Total_Revenue'] as num).toDouble(),
    );

    final categoryData = {
      'Coffee': {'color': const Color(0xFF8B4513), 'icon': Icons.coffee},
      'Drinks': {'color': const Color(0xFF2196F3), 'icon': Icons.local_drink},
      'Food': {'color': const Color(0xFFFF9800), 'icon': Icons.fastfood},
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4E342E).withOpacity(0.2),
                      const Color(0xFF4E342E).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pie_chart, color: Color(0xFF4E342E), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Category Revenue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Pie Chart Representation
          Center(
            child: SizedBox(
              height: 140,
              child: CustomPaint(
                painter: PieChartPainter(categories, totalRevenue, categoryData),
                child: const SizedBox(width: 140, height: 140),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Category Details
          ...categories.map((category) {
            final revenue = (category['Total_Revenue'] as num).toDouble();
            final percentage = (revenue / totalRevenue * 100);
            final categoryName = category['Category'] as String;
            final data = categoryData[categoryName];
            final color = data?['color'] as Color? ?? Colors.grey;
            final icon = data?['icon'] as IconData? ?? Icons.category;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: color, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${category['Total_Orders']} orders',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₱${revenue.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _emptyCategoryWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.pie_chart, color: Color(0xFF4E342E), size: 20),
              SizedBox(width: 12),
              Text(
                'Category Revenue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Icon(Icons.category_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No category data available',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Pie Chart
class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;
  final double totalRevenue;
  final Map<String, dynamic> categoryData;

  PieChartPainter(this.categories, this.totalRevenue, this.categoryData);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    double startAngle = -math.pi / 2;

    for (var category in categories) {
      final revenue = (category['Total_Revenue'] as num).toDouble();
      final percentage = revenue / totalRevenue;
      final sweepAngle = 2 * math.pi * percentage;
      final categoryName = category['Category'] as String;
      final data = categoryData[categoryName];
      final color = data?['color'] as Color? ?? Colors.grey;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw white circle in center for donut effect
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.6, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}