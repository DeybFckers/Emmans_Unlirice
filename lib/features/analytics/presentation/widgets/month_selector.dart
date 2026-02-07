import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  final String selectedMonth;
  final List<String> availableMonths;
  final ValueChanged<String> onChanged;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.availableMonths,
    required this.onChanged,
  });

  String _formatMonth(String month) {
    final parts = month.split('-');
    if (parts.length == 2) {
      final year = parts[0];
      final monthNum = int.parse(parts[1]);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[monthNum - 1]} $year';
    }
    return month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
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
            child: const Icon(Icons.calendar_month, color: Color(0xFF4E342E), size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Select Month:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4E342E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: selectedMonth,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4E342E)),
              style: const TextStyle(
                color: Color(0xFF4E342E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              items: availableMonths.map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(_formatMonth(month)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
