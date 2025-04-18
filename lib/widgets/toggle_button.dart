import 'package:flutter/material.dart';

class UnitToggleTab extends StatelessWidget {
  final bool isFirstSelected;
  final void Function(bool isFt) onToggle;
  final String text1;
  final String text2;

  const UnitToggleTab({
    super.key,
    required this.isFirstSelected,
    required this.onToggle,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1A1B18),
        borderRadius: BorderRadius.circular(132),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onToggle(true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                text1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color:
                      isFirstSelected ? Color(0xFFF3F4F1) : Color(0x30F3F4F1),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.5),
            width: 1,
            height: 24,
            color: Colors.grey[800],
          ),
          GestureDetector(
            onTap: () => onToggle(false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                text2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color:
                      isFirstSelected ? Color(0x30F3F4F1) : Color(0xFFF3F4F1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
