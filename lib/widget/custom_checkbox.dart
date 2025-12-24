import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constant.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final Color activeColor;
  final ValueChanged<bool> onChanged;
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.activeColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: value ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: value ? activeColor : Colors.grey.shade400, width: 2),
              boxShadow: [
                if (value)
                  BoxShadow(
                    color: activeColor.withValues(alpha: .3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: value ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: value ? Constant.primaryColor : Color(0xffB1B1B1), fontSize: 16),
        ),
      ],
    );
  }
}
