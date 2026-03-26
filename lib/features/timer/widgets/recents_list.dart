import 'package:flutter/material.dart';
import '../models/timer_model.dart';

class RecentsList extends StatelessWidget {
  final List<TimerModel> recents;
  final Function(TimerModel) onSelect;

  const RecentsList({
    super.key,
    required this.recents,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (recents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Recent',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E93),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...recents.map((timer) => _RecentItem(
          timer: timer,
          onTap: () => onSelect(timer),
        )),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  final TimerModel timer;
  final VoidCallback onTap;

  const _RecentItem({required this.timer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timer.displayTime,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: const Color(0xFFFFFFFF),
              ),
            ),
            Text(
              timer.label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF8E8E93),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
